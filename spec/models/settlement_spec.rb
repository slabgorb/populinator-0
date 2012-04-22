require 'spec_helper'

describe Settlement do
  before :each do 
    @settlement = Settlement.new(:name => 'New York')
    50.times do 
      @settlement.beings << Being.new
    end
    @settlement.rulers << Ruler.new(:name => 'Richard', :title => 'King')
  end
  
  it 'counts the population' do
    @settlement.population.should be(50)
  end

  it 'shows the ruler' do
    @settlement.rulers.first.name.should == 'Richard'
  end
  
end
