require 'spec_helper'

describe Gene do
  before :all do
    srand(1) # make random things happen consistently
    @c = FactoryGirl.create(:chromosome)
  end
  
  it "should be a hex string which resolves to an integer" do
    @c.genes.first.code.to_i(16).should be_a(Fixnum)
  end

  it "should be a seven digit hex number" do
    @c.genes.each do |gene|
      gene.code.length.should eq(7)
    end
  end
end
