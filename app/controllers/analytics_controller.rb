class AnalyticsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  def index
    @start_date = 7.days.ago.to_date
    @end_date = Date.tomorrow
    
    @complete_pomodoros = Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
    @void_pomodoros = Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => false, :created_at => @start_date..@end_date).count(:group => "date(pomodoros.created_at)")
  end

end
