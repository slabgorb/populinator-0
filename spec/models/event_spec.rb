require 'spec_helper'

describe Event do
  before :each do
    @adam = Person.new(:name => 'Adam', :gender => 'male')
    @death = Event.new(:name => 'Die', :description => "Die Adam die!", :effect => "{|b| b.die! }")
    @city = Settlement.new(:name => 'City')
    100.times do 
      @city.beings << Person.new()
    end
    @famine = Event.new({:name =>'famine',:description => 'had a famine',:effect => '{|settlement, virulence| settlement.beings.each{|b| b.die! if rand < virulence}}'})
  end
  
  it "affects the subject of the event" do
    @death.happened_to(@adam)
    @adam.alive?.should be_false
  end
  
  it "kills off people" do
    @famine.happened_to(@city, 1.0)
    @city.population.should be(0)
  end

end
