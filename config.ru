# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# provide ENV['RAILS_RELATIVE_URL_ROOT'] to mount app under a "folder".
# rails understands the environment variable and will use it in #url_for.
map ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  run Ketchup::Application
end
