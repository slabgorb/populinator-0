# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('lib/mongoid/chronology.rb')

# Initialize the rails application
Population::Application.initialize!
