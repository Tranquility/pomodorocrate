class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_widgets
  
  def setup_widgets
    @pomodoro = Pomodoro.where( :completed => nil ).first
    @recent_pomodoros = Pomodoro.order("created_at DESC").group("activity_id").limit(5)
  end
end
