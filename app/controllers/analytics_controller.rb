class AnalyticsController < ApplicationController
  
  def index
    @start_date = 7.days.ago.to_date
    @end_date = Date.today
    
    @complete_pomodoros = Pomodoro.where(:completed => true, :successful => true, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
    @void_pomodoros = Pomodoro.where(:completed => true, :successful => false, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
    
    #@complete_activities = Activity.where(:completed => true, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
    #@inprogress_activities = Activity.where(:completed => false, :created_at => @start_date..@end_date).count(:group => "date(created_at)")
  end

end
