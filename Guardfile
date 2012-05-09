guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^app/models/.+\.rb$})
  watch(%r{^app/controllers/.+\.rb$})
  watch(%r{^app/helpers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch(%r{^spec/factories}) { :rspec }
end

guard 'rspec', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{app})
  watch('spec/spec_helper.rb') { :rspec }
  watch('spec/*') { :rspec }
  watch(%r{features/support/}) { :cucumber }
end

guard 'bundler' do 
  watch('Gemfile')
end
