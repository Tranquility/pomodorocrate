module ApplicationHelper
  
  def pomodoros_as_image(nr_of_pomodoros, inactive = false)
    output = ""
    nr_of_pomodoros.times do |i|
      output += image_tag("tomato" + (inactive ? "_gray" : "") + ".jpg", :size => "16x16" )
    end
    raw output
  end
  
  def pomodoros_completed_ratio(completed_pomodoros, estimated_pomodoros)
    output = pomodoros_as_image(completed_pomodoros)
    
    pomodoros_left = estimated_pomodoros - completed_pomodoros;
    
    return raw output if pomodoros_left < 0
    
    raw output += pomodoros_as_image(pomodoros_left, true)
  end
  
end
