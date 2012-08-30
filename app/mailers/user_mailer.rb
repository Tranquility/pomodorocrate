class UserMailer < ActionMailer::Base
  default :from => Rails.configuration.notification_email
  
  def new_account_confirmation_email(user)
    @user = user
    mail( :to => @user.email,
          :subject => "Welcome to Rhapsody!")
  end
  
  def reset_password_email(user, url)
    @user = user
    @url = url
    
    mail( :to => user.email,
          :subject => "Password reset")
  end
  
end
