require 'spec_helper'

describe Chromosome do
  before :all do 
    srand(1)
    @c0 = FactoryGirl.create(:chromosome)
    @c1 = FactoryGirl.create(:chromosome)
    @c2 = FactoryGirl.create(:chromosome)
  end
  
  it "should give the indexed seed" do 
    @c0[0].should eq('6AC1F43')
  end
  
  context "mutation" do
    before :all do
      @m = FactoryGirl.create(:chromosome)
      @old = @m.to_s
      @m.mutate
    end

    it "should generate a random seed part" do
      Chromosome.rand_hex.should eq('47CB2D6')
    end
    
    it "should have a different genome" do
      @old.should_not eq(@m.to_s)
    end
    
  end
  
  context "reproduction" do
    before :all do
      srand(1)
      @c3 = @c1.reproduce_with @c2
    end
    it 'should have a genome pattern based on the parents' do
      # NOTE: this works because of the call to srand
      @c3.genes.first.code.should eq('CCFD988')
    end
    
    it 'should be a chromosome' do 
      @c3.should be_a(Chromosome)
    end
    
    it 'should be the same genome length as the parent' do     
      @c3.length.should eq(@c1.length)
    end
  end
end
