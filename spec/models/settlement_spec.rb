require 'spec_helper'

describe Settlement do
  
  before :all do 
    srand(0)
    @settlement = FactoryGirl.create(:settlement)
  end
  
  it 'counts the population' do
    @settlement.population.should be(101)
  end

  it 'shows the ruler' do     
    @settlement.rulers.first.surname.should == 'Plantagenet'
  end
  
  context 'seeding' do
    before :all do 
      @settlement.seed_original_families
    end

    it 'seeds original families with married couples' do
      @settlement.beings.select{ |s| s.married? }.empty?.should be_false
    end
    
    it 'puts children in families' do 
      @settlement.beings.select{ |s| s.children.present? }.empty?.should be_false
    end
    
    it 'should have some families' do
      @settlement.families.present?.should be_true
      @settlement.family_names.present?.should be_true
    end
    
    it 'should have people in the families' do
      @settlement.family_populations.should be { }
    end
    
    it 'should have spouses with the same last name' do 
      @settlement.beings.select{ |s| s.married? }.each do |someguy|
        someguy.surname.should eq(someguy.spouse.surname)
      end
    end
    
    it 'should not have any children to parents too old' do
      childbearers = @settlement.beings.select{ |s| s.children.present? }
      childbearers.each do |parent|
        parent.children.each do |child|
          (child.age > (Person.infertility - parent.age)).should be_false
        end
      end
    end
  end
end
