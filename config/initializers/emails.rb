## Please uncomment the 4 line below and provide your own set of email adresses.

Ketchup::Application.config.admin_email = 'Admin <ketchup+admin@localhost>'
Ketchup::Application.config.contact_email = 'Contact <ketchup+contact@localhost>'
Ketchup::Application.config.support_email = 'Contact <ketchup+support@localhost>'
Ketchup::Application.config.notification_email = 'Notification <ketchup+do-not-reply@localhost>'

[:admin_email, :contact_email, :support_email, :notification_email].each do |email|
  unless Rails.configuration.respond_to?(email) && Rails.configuration.send(email).present?
    raise "please provide config.#{email} in #{__FILE__}"
  end
end
