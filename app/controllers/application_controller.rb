class ApplicationController < ActionController::Base
  
  protect_from_forgery
  before_filter :setup_widgets
  
  def setup_widgets
    @pomodoro = Pomodoro.where( :completed => nil ).first
    @break = Break.where( :completed => nil ).first
    @recent_pomodoros = Pomodoro.select("DISTINCT(activity_id)").order("created_at DESC").limit(5)
    @upcoming_activities = Activity.where(:deadline => Time.now.midnight..(Time.now.midnight + 7.days), :completed => false)
    
    @today_remaining_pomodoros = 0
    Todotoday.all.each do |t|
      next if t.activity.completed
      @today_remaining_pomodoros += t.activity.estimated_pomodoros - t.activity.pomodoros.successful_and_completed.count
    end
    @today_completed_pomodoros = Pomodoro.successful_and_completed.where("date(created_at) = '#{Date.today}'").count
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
      
    end
    cond_strings.any? ? [ cond_strings.join(' and '), cond_params ] : nil
  end
  
end
