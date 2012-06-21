# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ketchup::Application.initialize!

# activity priority list options
Ketchup::Application.config.activity_priority_list = { 'High' => 'high', 'Medium high' => 'medium_high', 'Medium' => 'medium', 'Medium low' => 'medium_low', 'Low' => 'low', 'None' => 'none' }