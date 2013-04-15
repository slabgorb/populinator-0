require 'spec_helper'

describe Settlement do
  
  before :all do 
    srand(0)
    @settlement = FactoryGirl.create(:settlement)
  end
  
  it 'counts the population' do
    @settlement.stub(:population => @settlement.residents.map{ |m| m.alive? }.count)
    @settlement.population.should be(101)
  end

  it 'shows the ruler' do     
    @settlement.ruler.surname.should == 'Plantagenet'
  end
  
  context 'seeding' do
    before :all do 
      @settlement.seed!
    end

    it 'seeds original families with married couples' do
      # @settlement.residents.select{ |s| s.married? }.empty?.should be_false
    end
    
    it 'puts children in families' do 
      #   @settlement.residents.select{ |s| s.children.collect{ |c| c }.present? }.empty?.should be_false
    end
    
    it 'should have some families' do
      @settlement.families.present?.should be_true
      @settlement.family_names.present?.should be_true
    end
    
    it 'should have spouses with the same last name' do 
      @settlement.residents.select{ |s| s.married? }.each do |someguy|
        someguy.surname.should eq(someguy.spouse.surname)
      end
    end
    
    it 'should not have any children to parents too old' do
      childbearers = @settlement.residents.select{ |s| s.children.present? }
      childbearers.each do |parent|
        parent.children.each do |child|
          (child.age > (Person.infertility - parent.age)).should be_false
        end
      end
    end
  end
end
