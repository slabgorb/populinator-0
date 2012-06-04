require 'spec_helper'

describe Event do
  before :all do
    srand(2)
    @adam = FactoryGirl.create(:being)
    @death = FactoryGirl.create(:event, :name => 'Die', :description => "Die Adam die!", :effect => "{|b| b.die! }")
    @city = FactoryGirl.create(:settlement, :name => 'City')
    @famine =  FactoryGirl.create(:event, :name =>'famine',:description => 'had a famine',:effect => '{|settlement, virulence| settlement.residents.each{|b| b.die! if rand < virulence and b.alive? }}')
  end 
  
  it "affects the subject of the event" do
    @death.happened_to(@adam)
    @adam.alive?.should be_false
  end
  
  it "kills off people" do
    @famine.happened_to(@city, 1)
    @city.population.should == 1
  end

end
