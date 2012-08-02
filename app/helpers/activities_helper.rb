module ActivitiesHelper
  
  def due_at_status(date, content = "", just_relative_time = false)
    
    return nil unless date.instance_of? Date or date.instance_of? DateTime or date.instance_of? ActiveSupport::TimeWithZone
    
    output = '<span class="'
    point_in_time = ''
    use_time_for_comparing = (date.instance_of? DateTime or date.instance_of? ActiveSupport::TimeWithZone)
    
    if date     < (use_time_for_comparing ? DateTime.now : Date.today) then point_in_time = "past"
    elsif date == (use_time_for_comparing ? DateTime.now : Date.today) then point_in_time = "present"
    elsif date  > (use_time_for_comparing ? DateTime.now : Date.today) then point_in_time = "future"
    end
    
    return point_in_time if just_relative_time
    
    output += point_in_time
    raw output += "\">#{content.blank? ? date.to_date.to_s(:rfc822) : content}</span>"
  end

  def overdue_activities_badge
    activities_count = Activity.overdue( @current_user ).length
    raw( content_tag :span, activities_count, :class => ['badge', 'badge-important'] ) if activities_count > 0
  end
  
end
