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
    
    if Rails.env.production? and ActiveRecord::Base.configurations[Rails.env]['adapter'] == :postgresql
      @recent_pomodoros = Pomodoro.successful_and_completed.select("activity_id, id, created_at, successful, completed").where(:user_id, current_user.id).group("activity_id, pomodoros.id, created_at, successful, completed").order("pomodoros.created_at DESC").limit(5)
    else
      @recent_pomodoros = Pomodoro.group(:activity_id).order("created_at DESC").limit(5).find_all_by_user_id(current_user.id)
    end
    
    @upcoming_activities = Activity.where(:user_id => current_user.id, :completed => false).where("deadline >= '#{Time.now.midnight}'").order("activities.deadline ASC").limit(5)
    @overdue_activities = Activity.where("deadline < '#{Date.today}'").where(:user_id => current_user.id, :completed => false).limit(5)
    
    @today_remaining_pomodoros = 0
    Todotoday.find_all_by_user_id(current_user.id).each do |t|
      next if t.activity.completed
      difference = ( t.activity.estimated_pomodoros - t.activity.pomodoros.successful_and_completed.count )
      logger.debug("difference: " + difference.to_s)
      @today_remaining_pomodoros += (difference < 0 ? 0 : difference)
    end
    @today_completed_pomodoros = Pomodoro.successful_and_completed.where("date(pomodoros.created_at) = '#{Date.today}' AND user_id = ?", current_user.id).count
    
    @upcoming_appointments = Activity.where(:user_id => current_user.id, :completed => false).where("deadline >= '#{Time.now.midnight}'").where(:event_type => true).order("activities.start_at ASC").limit(5)
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  protected

    def search_conditions
      cond_params = {
        :q_name     => "%#{params[:q_name]}%",
        :q_project  => params[:q_project],
        :q_completed => params[:q_completed]
      }

      cond_strings = returning([]) do |strings|
      
        if params[:q_name]
          strings << "(activities.name like :q_name)" unless (params[:q_name].blank? or params[:q_name] == "Activity.")
        end
      
        if params[:q_project]
          strings << "(activities.project_id = :q_project)" unless (params[:q_project].blank? or params[:q_project] == "__none__" )
        end
        
        if params[:q_completed]
          strings << "(activities.completed = 't' OR activities.completed = '1')" if params[:q_completed] == 'Yes'
          strings << "(activities.completed = 'f' OR activities.completed = '0')" if params[:q_completed] == 'No'
        end
        
        # filter by logged user
        strings << "user_id = #{current_user.id}"
      
      end
      cond_strings.any? ? [ cond_strings.join(' and '), cond_params ] : nil
    end
    
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
end
