require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'mongoid'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  RSpec.configure do |config|
    config.before :each do
      Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
    end
  end
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  require 'factory_girl_rails'  
end




