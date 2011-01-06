module ActivitiesHelper
  
  def due_at_status(date)
    output = '<span class="'
    
    if date < Date.today then output += "past"
    elsif date == Date.today then output += "present"
    elsif date > Date.today then output += "future"
    end
    
    raw output += "\">#{date}</span>"
  end
  
end
