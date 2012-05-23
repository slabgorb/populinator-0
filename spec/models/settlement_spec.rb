require 'spec_helper'

describe Settlement do
  
  before :all do 
    srand(0)
    @settlement = FactoryGirl.create(:settlement)
  end
  
  it 'counts the population' do
    @settlement.population.should be(101)
  end

  it 'shows the ruler' do     
    @settlement.rulers.first.surname.should == 'Plantagenet'
  end
  
  context 'seeding' do
    before :all do 
      @settlement.seed_original_families
    end

    it 'seeds original families with married couples' do
      @settlement.beings.select{ |s| s.married? }.empty?.should be_false
    end
    
    it 'puts children in families' do 
      @settlement.beings.select{ |s| s.children.present? }.empty?.should be_false
    end
  end
end
