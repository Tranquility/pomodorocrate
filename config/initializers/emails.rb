## Please define at least DEFAULT_EMAIL (or better: *_EMAIL variables) in .env
## or modify the lines below at your own risk.
## To send email you should also check your SMTP_* variables.

Ketchup::Application.config.admin_email = ENV['ADMIN_EMAIL'] || ENV['DEFAULT_EMAIL']
Ketchup::Application.config.contact_email = ENV['CONTACT_EMAIL'] || ENV['DEFAULT_EMAIL']
Ketchup::Application.config.support_email = ENV['SUPPORT_EMAIL'] || ENV['DEFAULT_EMAIL']
Ketchup::Application.config.notification_email = ENV['NOTIFICATION_EMAIL'] || ENV['DEFAULT_EMAIL']

[:admin_email, :contact_email, :support_email, :notification_email].each do |email|
  unless Rails.configuration.respond_to?(email) && Rails.configuration.send(email).present?
    raise "please setup DEFAULT_EMAIL or *_EMAIL variables in #{Rails.root}/.env"
  end
end
