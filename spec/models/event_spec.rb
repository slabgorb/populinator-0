require 'spec_helper'

describe Event do
  before :each do
    @adam = Person.new(:name => 'Adam', :gender => 'male')
    @death = Event.new(:name => 'Die', :description => "Die Adam die!", :effect => "{|b| b.die! }")
  end
  
  it "affects the subject of the event" do
    @death.happened_to(@adam)
    @adam.alive?.should be_false
  end

end
