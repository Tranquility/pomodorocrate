class CalendarController < ApplicationController
  
  def index
    #@first_day_of_week = 1
    #@event_strips = Activity.event_strips_for_month(@shown_month, @first_day_of_week)
    
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    # @event_strips = Activity.event_strips_for_month(@shown_month)
    @event_strips = Activity.event_strips_for_month(@shown_month, :conditions => "user_id = #{current_user.id}")
    
  end
  
end
