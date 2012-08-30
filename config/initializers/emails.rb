## Please define at least DEFAULT_EMAIL (or better: *_EMAIL variables) in .env
## or modify the lines below at your own risk.
## To send email you should also check your SMTP_* variables.

default_email = ENV['DEFAULT_EMAIL'] || 'rhapsodyapp@gmail.com'
Ketchup::Application.config.admin_email = ENV['ADMIN_EMAIL'] || default_email
Ketchup::Application.config.contact_email = ENV['CONTACT_EMAIL'] || default_email
Ketchup::Application.config.support_email = ENV['SUPPORT_EMAIL'] || default_email
Ketchup::Application.config.notification_email = ENV['NOTIFICATION_EMAIL'] || default_email

[:admin_email, :contact_email, :support_email, :notification_email].each do |email|
  unless Rails.configuration.respond_to?(email) && Rails.configuration.send(email).present?
    raise "please setup DEFAULT_EMAIL or *_EMAIL variables in #{Rails.root}/.env"
  end
end
