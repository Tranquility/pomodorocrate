module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), url_for({:month => month_date.month, :year => month_date.year, :q_name => params[:q_name], :q_project => params[:q_project], :q_tags => params[:q_tags], :q_completed => params[:q_completed] }), :class => :button)
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"
      #:first_day_of_week => @first_day_of_week
    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      activity = args[:event] 
      
      (css_class ||= Array.new).clear
      css_class << :activityCompleted if activity.completed
      css_class << activity.priority if activity.priority != :none
      
      %(<a href="/activities/#{activity.id}" title="#{h(activity.name)}" #{ ('class="' + css_class.join(' ') + '"') unless css_class.empty? }>#{h activity.name}</a>)
    end
  end
end
