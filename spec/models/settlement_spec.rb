require 'spec_helper'

describe Settlement do
  
  before :each do 
    @marriage = FactoryGirl.create(:marriage)

    @settlement = Settlement.new(:name => 'New York')
    50.times do 
      @settlement.beings << Person.create(:age => Person.random_age)
    end
    @settlement.rulers << Ruler.new(:surname => 'Plantagenet', :title => 'King')
  end
  
  it 'counts the population' do
    @settlement.population.should be(50)
  end

  it 'shows the ruler' do
    @settlement.rulers.first.surname.should == 'Plantagenet'
  end

  it 'seeds original families with siblings' do
    @settlement.seed_original_families
    @settlement.beings.select{ |s| s.married? }.empty?.should be_false
  end

end
