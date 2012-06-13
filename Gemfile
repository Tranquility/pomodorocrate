source 'http://rubygems.org'

gem 'rails', '3.0.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json', '~> 1.7.3' # upgrade to not have Iconv deprecation message
gem 'tzinfo', '~> 0.3.33' # avoid DateTime.new0 bug (not available on 1.9.x)

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'gravatar_image_tag', '~> 1.1.2'
gem 'will_paginate', '~> 3.0.3'
gem 'jquery-rails', '~> 0.2.6'
gem 'high_voltage', '~> 1.1.1'
gem 'recaptcha', :require => 'recaptcha/rails' #, :git => 'git://github.com/ambethia/recaptcha.git'
gem 'event-calendar', :require => 'event_calendar'

group :development do
  gem 'faker', '~> 1.0.1'
end

#group :test do
#  gem 'rspec-rails', '2.3.0'
#  gem 'webrat', '0.7.1'
#  gem 'factory_girl_rails', '1.0'
#end

# enable your favorite database adapter.
group :production do
  #gem 'sqlite3'
  #gem 'pg'
  #gem 'mysql'
end

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
