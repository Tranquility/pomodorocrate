class ApplicationController < ActionController::Base
  
  protect_from_forgery
  include SessionsHelper
  
  before_filter :set_timezone, :setup_widgets, :unless => :load_user_settings?
  before_filter :mailer_set_url_options
  
  def set_timezone
    Time.zone = current_user.time_zone unless current_user.time_zone.blank?
  end
  
  def load_user_settings?
    current_user.blank?
  end
  
  def setup_widgets
    @pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).last
    @break = Break.where( :user_id => current_user.id, :completed => nil ).first
    
    # to list the current user's latest pomodoro per open activity we need to fallback to find_by_sql, as the intuitive method:
    #   current_user.pomodoros.joins(:activity).where('activities.completed' => false).group(:activity_id).order(...).limit(...)
    # will generate broken sql on stricter databases (we implicitly select pomodoro.* which is not included in the 'group' clause)
    # the following sql should work on sqlite3, postgres and (probably) mysql, but let's be conservative and only enable for postgres
    if ActiveRecord::Base.connection.adapter_name.downcase.to_sym == :postgresql
      last_user_pomodoro_per_activity = %Q{
        SELECT p1.activity_id, p1.id, p1.created_at, p1.successful, p1.completed
        FROM pomodoros p1 INNER JOIN activities a ON p1.activity_id = a.id
                          INNER JOIN pomodoros p2 ON p1.activity_id = p2.activity_id
        WHERE p1.user_id = ? AND a.completed = ?
        GROUP BY p1.activity_id, p1.id, p1.created_at, p1.successful, p1.completed
        HAVING p1.created_at = MAX(p2.created_at)
        ORDER BY p1.created_at DESC
        LIMIT 5 ;
      }
      sanitized_sql = ActiveRecord::Base.send(:sanitize_sql, [last_user_pomodoro_per_activity, current_user.id, false], '') # hack
      @recent_pomodoros = Pomodoro.find_by_sql(sanitized_sql)
    else
      # original way, working with sqlite3 and mysql, but definitely broken with postgres.
      @recent_pomodoros = current_user.pomodoros.joins(:activity).where('activities.completed' => false).group(:activity_id).order("created_at DESC").limit(5)
    end
    
    @upcoming_activities = Activity.not_completed( current_user ).scheduled( current_user ).upcoming( current_user ).order("activities.deadline ASC").limit(5)
    @overdue_activities = Activity.not_completed( current_user ).scheduled( current_user ).overdue( current_user ).order("activities.deadline ASC").limit(5)
    
    @today_remaining_pomodoros = 0
    Todotoday.find_all_by_user_id(current_user.id).each do |t|
      next if t.activity.completed
      difference = ( t.activity.estimated_pomodoros - t.activity.pomodoros.successful_and_completed.count )
      logger.debug("difference: " + difference.to_s)
      @today_remaining_pomodoros += (difference < 0 ? 0 : difference)
    end
    @today_completed_pomodoros = Pomodoro.successful_and_completed.where("pomodoros.created_at BETWEEN '#{Date.today.beginning_of_day.utc}' AND '#{Date.today.end_of_day.utc}' AND user_id = ?", current_user.id).count
    
    @upcoming_appointments = Activity.where(:user_id => current_user.id, :completed => false).where("deadline >= '#{Date.today}'").where(:event_type => true).order("activities.start_at ASC").limit(5)
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  protected

    def search_conditions( table_name = 'activities' )
      
      cond_params = {
        :q_name     => "%#{params[:q_name]}%",
        :q_project  => params[:q_project],
        :q_completed => params[:q_completed]
      }

      strings = []
      
      if params[:q_name]
        strings << "(activities.name like :q_name or activities.description like :q_name)" unless (params[:q_name].blank? or params[:q_name] == "Activity.")
      end

      if params[:q_project]
        strings << "(activities.project_id = :q_project)" unless (params[:q_project].blank? or params[:q_project] == "__none__" )
      end

      if params[:q_completed]
        strings << "(activities.completed = '" + (ActiveRecord::Base.connection.adapter_name.downcase.to_sym == :mysql ? '1' : 't') + "')" if params[:q_completed] == 'Yes'
        strings << "(activities.completed = '" + (ActiveRecord::Base.connection.adapter_name.downcase.to_sym == :mysql ? '0' : 'f') + "')" if params[:q_completed] == 'No'
      end

      # filter by logged user
      strings << "#{ table_name }.user_id = #{ current_user.id }"

      strings.any? ? [ strings.join(' and '), cond_params ] : nil
    end
    
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
end
