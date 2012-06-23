require 'spec_helper'

describe BeingsHelper do
  before :all do
    srand(1)
    @male = FactoryGirl.create(:being, gender: 'male')
    3.times { @male.chromosomes << Chromosome.new.randomize! }
    @female = FactoryGirl.create(:being, gender: 'female')
    @neuter = FactoryGirl.create(:being, gender: 'neuter')
  end

  describe 'possessive' do
    it 'returns his for males' do
      helper.possessive_pronoun(@male).should == 'his'
    end      
    it 'returns her for females' do
      helper.possessive_pronoun(@female).should == 'her'
    end      
    it 'returns its for neuter' do
      helper.possessive_pronoun(@neuter).should == 'its'
    end      
  end
  
  describe 'strength' do
    before :all do
      srand 1
    end
    it 'returns a strength string' do
      helper.strength(2).should == 'especially'
    end
  end
  
  describe 'describe' do
    it 'returns a descriptive string' do
      helper.send(:describe_paragraph, @male).should == "Red's reasoning is  concrete. His hair color is especially brown. Red's handedness is  left handed. Red's skin color is noticeably black. His eye color is  purple. His nose shape is rather upturned. His build is marginally medium. Red's disposition is  calm."
    end
  end
  
end
