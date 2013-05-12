require 'spec_helper'

describe Event do
  before :all do
    srand(2)
    @adam = FactoryGirl.create(:being)
    @death = FactoryGirl.create(:event, :name => 'Die', :description => "Die Adam die!", :effect => "{|b| b.die! }")
    @city = FactoryGirl.create(:settlement, :name => 'City')
    @famine =  FactoryGirl.create(:event, :name =>'famine',:description => 'had a famine',:effect => '{|settlement, virulence| settlement.residents.each{|b| b.die! if rand < virulence and b.alive? }}')
  end

end
