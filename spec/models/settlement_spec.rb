require 'spec_helper'

describe Settlement do
  
  before :all do 
    srand(0)
    @marriage = FactoryGirl.create(:marriage)
    @settlement = FactoryGirl.create(:settlement)
  end
  
  it 'counts the population' do
    @settlement.population.should be(101)
  end

  it 'shows the ruler' do
    @settlement.rulers.first.surname.should == 'Plantagenet'
  end

  it 'seeds original families with siblings' do
    @settlement.seed_original_families(@marriage)
    @settlement.beings.select{ |s| s.married? }.empty?.should be_false
  end
end
