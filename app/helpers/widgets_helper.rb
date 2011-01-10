module WidgetsHelper
  
  def setup_widgets
    @recent_pomodoros = Pomodoro.order("created_at DESC").group("activity_id").limit(5)
  end
  
end
