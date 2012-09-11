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
    activities_count = Activity.scheduled( @current_user ).overdue( @current_user ).count
    raw( content_tag :span, activities_count, :class => ['badge', 'badge-important'], :title => 'Scheduled and overdue' ) if activities_count > 0
  end

  def total_activities_badge
    return # disable count bubble

    activities_count = @current_user.activities.scheduled( @current_user ).where( :completed => false ).count
    raw( content_tag :span, activities_count, :class => ['badge', 'badge-info'], :title => 'All' ) if activities_count > 0
  end

  def total_next_activities_badge
    activities_count = @current_user.activities.not_completed( @current_user ).upcoming( @current_user ).scheduled( @current_user ).count
    raw( content_tag :span, activities_count, :class => ['badge', 'badge-info'], :title => 'Scheduled this week' ) if activities_count > 0
  end

  def total_someday_activities_badge
    return # disable count bubble

    activities_count = @current_user.activities.unscheduled( @current_user ).count
    raw( content_tag :span, activities_count, :class => ['badge', 'badge-info'], :title => 'All' ) if activities_count > 0
  end

  def activity_completed_status( a )
    return '' if a.someday and ! a.completed
    raw '<li>' + ( a.completed ? "Completed" : "Due at: #{ due_at_status( a.deadline ) }" ) + '</li>'
  end

  def activity_has_info_bar( a )
    return ( !a.someday or a.event_type? or !a.tag_list.blank? )
  end
  
end