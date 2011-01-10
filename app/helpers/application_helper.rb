module ApplicationHelper
  
  def pomodoros_as_image(nr_of_pomodoros, inactive = false)
    output = ""
    nr_of_pomodoros.times do |i|
      output += image_tag("pomodoro" + (inactive ? "_not_started" : "_completed") + ".png", :size => "14x14" )
    end
    raw output
  end
  
  def pomodoros_completed_ratio(completed_pomodoros, estimated_pomodoros)
    output = pomodoros_as_image(completed_pomodoros)
    
    pomodoros_left = estimated_pomodoros - completed_pomodoros;
    
    return raw output if pomodoros_left < 0
    
    raw output += pomodoros_as_image(pomodoros_left, true)
  end
  
  def is_current_page?(controller_name)
    return true if controller_name.to_s == request.path_parameters[:controller]
    false
  end
  
  def setup_widgets
    @recent_pomodoros = Pomodoro.order("created_at DESC").group("activity_id").limit(5)
  end
  
  def in_progress_marker(pomodoro, activity)
    return raw '<span class="inProgressMarker">in progress</span>' unless pomodoro.nil? or pomodoro.activity != activity
		return
  end
  
  def in_progress?(pomodoro, activity)
    return (!pomodoro.nil? && pomodoro.activity == activity) 
  end
  
  def todotoday_marker(activity)
    return raw '<span class="todotodayMarker">todo today</span>' unless activity.todotoday.nil? or activity.completed
  end

end
