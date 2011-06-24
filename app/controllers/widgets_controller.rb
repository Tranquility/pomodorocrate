class WidgetsController < ApplicationController
  
  def active_pomodoro
  end 
  
  def activity_status
    respond_to do |format|
      format.js     { render :layout => false }
      format.html   # index.html.erb
    end
  end
  
  def recent_activities
    respond_to do |format|
      format.js     { render :layout => false }
      format.html   # index.html.erb
    end
  end
  
  def upcoming_activities
    respond_to do |format|
      format.js     { render :layout => false }
      format.html   # index.html.erb
    end
  end
  
  def overdue_activities
    respond_to do |format|
      format.js     { render :layout => false }
      format.html   # index.html.erb
    end
  end

end
