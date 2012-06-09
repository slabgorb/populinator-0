require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BeingsHelper. For example:
#
# describe BeingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe BeingsHelper do
  before :all do
    @male = FactoryGirl.create(:being, gender: 'male')
    @female = FactoryGirl.create(:being, gender: 'female')
    @neuter = FactoryGirl.create(:being, gender: 'neuter')
  end
  describe 'possessive' do
    it 'returns his for males' do
      helper.possessive(@male.gender).should == 'his'
    end      
    it 'returns her for females' do
      helper.possessive(@female.gender).should == 'her'
    end      
    it 'returns its for neuter' do
      helper.possessive(@neuter.gender).should == 'its'
    end      
  end
  describe 'strength' do
    before :all do
      srand 1
    end
    it 'returns a strength string' do
      helper.strength({ :hay => ['no',2]}).should == 'especially'
    end
  end
end
