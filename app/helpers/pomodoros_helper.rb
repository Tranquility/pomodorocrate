module PomodorosHelper
  
  def pomodoro_in_progress?
    p = Pomodoro.where( :completed => nil ).where(:user_id, current_user).first
    !p.nil?
  end
  
end
