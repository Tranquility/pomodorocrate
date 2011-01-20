class ApplicationController < ActionController::Base
  
  protect_from_forgery
  include SessionsHelper
  
  before_filter :setup_widgets, :unless => :load_user_settings?
  
  def load_user_settings?
    current_user.blank?
  end
  
  def setup_widgets
    @pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).first
    @break = Break.where( :user_id => current_user.id, :completed => nil ).first
    
    if Rails.env.production? and ActiveRecord::Base.configurations[Rails.env]['adapter'] == :postgresql
      @recent_pomodoros = Pomodoro.successful_and_completed.select("activity_id, id, created_at, successful, completed").where(:user_id, current_user.id).group("activity_id, pomodoros.id, created_at, successful, completed").order("pomodoros.created_at DESC").limit(5)
    else
      @recent_pomodoros = Pomodoro.successful_and_completed.group(:activity_id).order("created_at DESC").limit(5).find_all_by_user_id(current_user.id)
    end
    
    @upcoming_activities = Activity.where(:user_id => current_user.id, :deadline => Time.now.midnight..(Time.now.midnight + 7.days), :completed => false).limit(5)
    @overdue_activities = Activity.where("deadline < '#{Date.today}'").where(:user_id => current_user.id, :completed => false).limit(5)
    
    @today_remaining_pomodoros = 0
    Todotoday.find_all_by_user_id(current_user.id).each do |t|
      next if t.activity.completed
      @today_remaining_pomodoros += ( t.activity.estimated_pomodoros - t.activity.pomodoros.successful_and_completed.count )
    end
    @today_completed_pomodoros = Pomodoro.successful_and_completed.where("date(pomodoros.created_at) = '#{Date.today}' AND user_id = ?", current_user.id).count
  end
  
  protected

    def search_conditions
      cond_params = {
        :q_name     => "%#{params[:q_name]}%",
        :q_project  => params[:q_project],
        :q_deadline => Chronic.parse(params[:q_deadline])
      }

      cond_strings = returning([]) do |strings|
      
        if params[:q_name]
          strings << "(activities.name like :q_name)" unless (params[:q_name].blank? or params[:q_name] == "Activity.")
        end
      
        if params[:q_project]
          strings << "(activities.project_id = :q_project)" unless (params[:q_project].blank? or params[:q_project] == "__none__" )
        end
      
        if params[:q_deadline]
          #strings << "(activities.deadline = #{cond_params[:q_deadline].to_date})" unless (params[:q_deadline].blank?)
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
