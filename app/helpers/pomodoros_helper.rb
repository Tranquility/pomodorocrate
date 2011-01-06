module PomodorosHelper
  
  def pomodoro_in_progress?
    p = Pomodoro.where( :completed => nil ).first
    !p.nil?
  end
  
end
