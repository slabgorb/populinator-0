# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('lib/mongoid/chronology.rb')
Mime::Type.register "text/markdown", :markdown


# Initialize the rails application
Population::Application.initialize!
