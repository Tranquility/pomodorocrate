module PomodorosHelper
  
  def pomodoro_in_progress?
    #p = Pomodoro.where( :completed => nil ).where(:user_id, current_user).first
    p = Pomodoro.where( :completed => nil ).find_by_user_id(current_user)
    !p.nil?
  end
  
end
