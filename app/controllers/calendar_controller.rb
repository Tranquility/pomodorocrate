class CalendarController < ApplicationController
  
  def index
    #@first_day_of_week = 1
    #@event_strips = Activity.event_strips_for_month(@shown_month, @first_day_of_week)
    
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    #@event_strips = Activity.event_strips_for_month(@shown_month)
    
    if params[:q_tags] and params[:q_tags] != 'Tags.' and !params[:q_tags].blank? 
      activities = Activity.find_tagged_with(params[:q_tags])
      activities_tag_filtering = 'activities.id IN (?)', activities.collect { |a| a.id }
      
      @event_strips = Activity.where(activities_tag_filtering).event_strips_for_month(@shown_month, :conditions => search_conditions)
    else
      @event_strips = Activity.event_strips_for_month(@shown_month, :conditions => search_conditions)
    end
    
    respond_to do |format|
      format.js     {  }
      format.html   # index.html.erb
      format.xml    { render :xml => @event_strips }
      format.json   { render :json => @event_strips }
    end
    
  end
  
end
