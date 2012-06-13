class ContactMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => Rails.configuration.contact_email
  
  def contact_request(contact_request)
    @contact_request = contact_request
    mail(:from => @contact_request.user.email, :to => admin_email, :subject => "Contact request from #{@contact_request.user.name}")
  end
  
  def contact_request_from_site(contact_request)
    @contact_request = contact_request
    mail(:from => @contact_request.email, :to => admin_email, :subject => "Contact request from #{@contact_request.name}")
  end

  private

  def admin_email
    Rails.configuration.admin_email
  end
end
