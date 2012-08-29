module TodotodaysHelper

  def remaining_todo_todays
    remaining_count = Todotoday.joins( :activity ).where( 'activities.completed' => false ).count
    raw( content_tag :span, remaining_count, :class => ['badge'] ) if remaining_count > 0
  end

  def overdue_todo_todays
    remaining_count = Todotoday.joins( :activity ).where( 'activities.completed' => false ).where( "activities.end_at < ?", Date.today ).count
    raw( content_tag :span, remaining_count, :class => ['badge', 'badge-important'] ) if remaining_count > 0
  end

end
