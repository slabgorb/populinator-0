require 'spec_helper'

describe Person do
  before :each do
    @adam = FactoryGirl.create(:person, :name => 'Adam', surname: 'Man', :gender => 'male')
    @eve = FactoryGirl.create(:person, :name => 'Eve', surname: 'Man', :gender => 'female')
    @adam.marry @eve
    @abel = @adam.reproduce @eve
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

  it 'should give the child a first name' do
    child = @adam.reproduce @eve
    child.given_name.should_not be_nil
  end

  it 'gets the last name of the parent' do
    @baby = FactoryGirl.create(:person, name: 'Baby', surname: 'Baby')
    @adam.adopt @baby
    @baby.surname.should eq('Man')
    @abel.surname.should eq @eve.surname
    @abel.surname.should eq @adam.surname
  end

  it 'should update the name when the surname is changed' do
    @adam.surname = 'Rocketman'
    @adam.name.should match(/Rocketman/)
    @adam.surname = 'Foobooloo'
    @adam.name.should match(/Foobooloo/)
  end

end
