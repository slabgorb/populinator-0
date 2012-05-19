require 'spec_helper'

describe Person do
  before :each do
    @adam = FactoryGirl.create(:person, :name => 'Adam', :gender => 'male')
    @eve = FactoryGirl.create(:person, :name => 'Eve', :gender => 'female')
    @adam.marry @eve
  end
  
  it 'recognizes spouses' do 
    @adam.married?.should be_true
    @eve.married?.should be_true
    @adam.spouses.first.should == @eve
  end
  
  it 'only recognizes living spouses' do
    @eve.die!
    @adam.married?.should be_false
  end
  
  it 'can look at a king' do
    ruler = FactoryGirl.create(:ruler)
    lambda { @adam.surname <=> ruler.surname }.should_not raise_error
  end
   
end
