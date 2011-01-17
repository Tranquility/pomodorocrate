class AnalyticsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  def index
    @start_date = 7.days.ago.to_date
    @end_date = Date.tomorrow
    
    @complete_pomodoros = Pomodoro.where("projects.user_id" => current_user, :completed => true, :successful => true, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
    @void_pomodoros = Pomodoro.where("projects.user_id" => current_user, :completed => true, :successful => false, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
    
    #@complete_activities = Activity.where(:completed => true, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
    #@inprogress_activities = Activity.where(:completed => false, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
  end

end
