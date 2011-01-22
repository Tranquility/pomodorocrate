class UserMailer < ActionMailer::Base
  default :from => "notifications@pomodorocrate.com"
  
  def new_account_confirmation_email(user)
    
  end
  
  def reset_password_email(user, url)
    @user = user
    @url = url
    
    mail( :to => user.email,
          :subject => "Password reset")
  end
  
end
