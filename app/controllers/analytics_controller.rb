class AnalyticsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  def index
    if params[:q_interval].to_i != 7 and params[:q_interval].to_i != 30
      params[:q_interval] = 7
    end
    
    @graph_interval = params[:q_interval].to_i
    
    @start_date = @graph_interval.days.ago.to_date
    @end_date = Date.tomorrow
    
    @complete_pomodoros = Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
    @void_pomodoros = Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => false, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
    
    @estimated_pomodoros = Activity.select(:estimated_pomodoros).where(:user_id => current_user.id, :updated_at => @start_date..@end_date).group("date(activities.updated_at)").sum(:estimated_pomodoros)
    
    @worked_time = Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).group("date(pomodoros.created_at)").sum(:duration)
  end

end
