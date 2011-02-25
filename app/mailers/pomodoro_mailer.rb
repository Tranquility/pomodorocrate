class PomodoroMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "notifications@pomodorocrate.com"
  
  def completed_pomodoro_email(user, pomodoro)
    @user = user
    @pomodoro = pomodoro
    @url = signin_url
    
    mail( :to => user.email,
          :subject => "Pomodoro finished: " + @pomodoro.activity.name)
  end
  
  def successful_pomodoro_email(user, pomodoro)
    @user = user
    @pomodoro = pomodoro
    @url = signin_url
    
    mail( :to => user.email,
          :subject => "Pomodoro successfully completed: " + @pomodoro.activity.name)
  end
  
  def voided_pomodoro_email(user, pomodoro)
    @user = user
    @pomodoro = pomodoro
    @url = signin_url
    
    mail( :to => user.email,
          :subject => "Pomodoro voided: " + @pomodoro.activity.name)
  end
  
end
