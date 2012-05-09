require 'spec_helper'

describe Chromosome do
  before :all do 
    @c0 = FactoryGirl.create(:chromosome, :seed => '111111')
    @c1 = FactoryGirl.create(:chromosome)
    @c2 = FactoryGirl.create(:chromosome, :seed => '000000')
  end
  
  it "should give the indexed seed" do 
    @c0[0].should eq(false)
  end
  
  context 'fitness' do 
    it 'should know the fitness' do
      @c0.fitness.should eq(6)
      @c1.fitness.should eq(3)
      @c2.fitness.should eq(0)
    end
  end

  context "mutation" do
    before :all do
      @m = FactoryGirl.create(:chromosome)
      @old = @m.seed.dup
      srand(1)
      @m.mutate
    end
    
    it "should have a different genome" do
      @old.should_not eq(@m.seed)
    end
    
  end
  
  context "reproduction" do
    before :all do
      srand(1)
      @c3 = @c1.reproduce_with @c2
    end
    it 'should have a genome pattern based on the parents' do
      # NOTE: this works because of the call to srand
      @c3.seed.should eq('ABAAAA')
    end
    
    it 'should be a chromosome' do 
      @c3.should be_a(Chromosome)
    end
    
    it 'should be the same genome length as the parent' do     
      @c3.length.should eq(@c1.length)
    end
  end
end
