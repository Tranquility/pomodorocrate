Ketchup::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Rhapsody] ",
  :sender_address => %{"notifier" <notifier@rhapsodyapp.com>},
  :exception_recipients => %w{adrian@rhapsodyapp.com}