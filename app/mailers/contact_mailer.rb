class ContactMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "contact@pomodorocrate.com"
  
  def contact_request(contact_request)
    @contact_request = contact_request
    mail(:to => "adrian@reveloper.com", :subject => "Contact request from #{@contact_request.user.name}")
  end
end
