module ApplicationHelper
  
  def pomodoros_as_image(nr_of_pomodoros, inactive = false, activity = nil)
    output = ""
    return output if nr_of_pomodoros.nil?
    
    image_data = image_tag("pomodoro" + (inactive ? "_not_started" : "_completed") + ".png", :size => "12x12", :title => inactive ? "Estimated but not yet completed beats" : "Successfuly completed beats" )

    nr_of_pomodoros.times do |i|
      output += (link_to_if (i == 0 and !activity.nil? and !activity.completed), image_tag("pomodoro_complete_manually.png", :size => "12x12" ), pomodoros_path(:activity_id => activity, :autocomplete => true), {:method => 'post', :remote => true, "data-type" => :text, "title" => "Manually mark one beat as successfuly completed", "data-action" => "create-update-pomodoro", :data => { :confirm => 'This will manually mark a beat as successfully completed. Are you sure?' } } do
        image_data
      end)
    end
    
    raw output
  end
  
  def pomodoros_count(completed_pomodoros, estimated_pomodoros)
    return completed_pomodoros if completed_pomodoros > estimated_pomodoros
    return estimated_pomodoros if estimated_pomodoros >= completed_pomodoros
  end
  
  def pomodoros_icons_width(completed_pomodoros, estimated_pomodoros)
    pomodoros_count(completed_pomodoros, estimated_pomodoros) * 14 < 60 ? 60 : pomodoros_count(completed_pomodoros, estimated_pomodoros) * 14
  end
  
  def pomodoros_completed_ratio(completed_pomodoros, estimated_pomodoros, activity = nil)
    output = pomodoros_as_image(completed_pomodoros)
    
    pomodoros_left = estimated_pomodoros - completed_pomodoros;
    
    return raw output if pomodoros_left < 0
    
    raw output += pomodoros_as_image(pomodoros_left, true, activity)
  end
  
  def is_current_page?( controller_name, action_name = 'index' )
    return true if controller_name.to_s == request.path_parameters[:controller] and action_name.to_s == request.path_parameters[:action]
    false
  end
  
  def setup_widgets
    @recent_pomodoros = Pomodoro.order("created_at DESC").group("activity_id").limit(5)
  end
  
  def in_progress_marker(pomodoro, activity)
    #return raw '<span class="inProgressMarker">in progress</span>' unless pomodoro.nil? or pomodoro.activity != activity
    return raw '<i class="ico-in-progress" title="In progress" data-placement="right"></i>' unless pomodoro.nil? or pomodoro.activity != activity
		return
  end
  
  def in_progress?(pomodoro, activity)
    return (!pomodoro.nil? && pomodoro.activity == activity) 
  end
  
  def todotoday_marker(activity)
    # return raw '<span class="todotodayMarker">todo today</span>' unless activity.todotoday.nil? or activity.completed
    return raw '<i class="ico-in-today" title="To be done today" data-placement="right"></i>' unless activity.todotoday.nil? or activity.completed
  end
  
  def text_format(text)
    return text.blank? ? "" : simple_format( auto_link text, :all, :class => :external ).html_safe
  end
  
  def title
    return @title unless @title.nil?
    request.path_parameters[:controller].capitalize
  end
  
  def hms_format(datetime, seconds = false)
    dts = DateTime.parse(datetime.to_s) 
    output = (dts.hour < 10 ? '0' << dts.hour.to_s : dts.hour).to_s << ":" << (dts.minute < 10 ? '0' << dts.minute.to_s : dts.minute).to_s
    #output << (dts.second < 10 ? '0' << dts.second : dts.second) if seconds
  end

  def active_view_class?( sort_by )
    active = case sort_by
      when :date
        true if params[:controller] != 'calendar' and ( params[:sort_by].nil? or params[:sort_by].blank? )
      when :priority
        true if params[:controller] != 'calendar' and params[:sort_by] == 'priority'
      when :calendar
        true if params[:controller] == 'calendar'
      when :project
        true if params[:controller] != 'calendar' and params[:sort_by] == 'project'
      else ''
    end

    active ? 'btn-info active' : ''
  end

end
