# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ketchup::Application.initialize!

# automatically remove dead tags
Tag.destroy_unused = true