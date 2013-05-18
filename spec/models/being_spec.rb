require 'spec_helper'

describe Being do
  before :all do
    @adam = FactoryGirl.create(:being, :name => 'Adam', :gender => 'male')
  end

  context 'life and death' do
    it 'should have the birth event' do
      @adam.birth!
      @adam.history.where(:name => "Birth").first.should_not be_nil
    end

    it 'knows when it is alive' do
      @adam.alive?.should be_true
      @adam.dead?.should be_false
    end

    it 'knows when it is dead' do
      @adam.die!
      @adam.alive?.should be_false
      @adam.dead?.should be_true
      @adam.resurrect!
    end

    it 'should have an event when it dies' do
      @adam.die!
      @adam.history.where(:name => 'Death').first.should_not be_nil
      @adam.resurrect!
    end

    it 'cannot die twice' do
      @adam.die!
      @adam.resurrect!
    end
  end

  context 'injuries' do
    before :all do
      @damage = FactoryGirl.create :damage
      @adam.hurt(@damage)
    end

    it 'can be damaged' do
      @adam.hurt?.should be_true
    end

    it 'can be healed of damage' do
      @adam.heal(@damage)
      @adam.hurt?.should be_false
    end
  end

  context 'reproduction' do
    before :all do
      @eve = FactoryGirl.create(:being, :name => 'Eve', :gender => 'female')
      @cain = @adam.reproduce(@eve, 'Cain', 'male')
    end

    it 'knows about children' do
      @adam.children.first.should == @cain
      b = Being.find(@adam.id).children
      b.first.should == @cain
    end

    it 'knows when it is a parent' do
      @adam.parent?.should be_true
      @eve.parent?.should be_true
    end

    it 'cannot reproduce with itself if not neuter' do
      lambda { @adam.reproduce }.should raise_error(ReproductionException)
    end


    context 'relatives' do
      before :all do
        @abel = @adam.reproduce(@eve, 'Abel', 'male')
        @shirley = @adam.reproduce(@eve, 'Shirley', 'female')
        @ralph = @adam.reproduce(@eve, 'Ralph', 'male')
        @mary = @adam.reproduce(@eve, 'Mary', 'female')
        @bob  = @abel.reproduce(@mary, 'Bob', 'male')
        @alice  = @shirley.reproduce(@ralph, 'Alice', 'female')
      end

      it 'should get the name right' do
        @abel.name.should eq("Abel")
      end

      it 'knows about children' do
        @cain.child_of?(@adam).should be_true
      end

      it 'knows about parents' do
        @adam.parent_of?(@cain).should be_true
      end

      it 'knows about siblings' do
        @cain.sibling_of?(@abel).should be_true
        @abel.sibling_of?(@cain).should be_true
      end

    end

  end

  context 'genetic_map' do
    before :each do
      srand(0)
      @expressions = {
        hair: {
          blond:['01'],
          red:['02'],
          pink:['03'],
          plaid:['FF']
        }
      }
      20.times  { @adam.chromosomes << Chromosome.new.randomize! }
    end

    it 'has chromosomes' do
      (@adam.chromosomes.length > 0).should be_true
    end

    it 'has genes in the chromosomes' do
      (@adam.chromosomes.first.genes.length > 0).should be_true
    end


    it 'describes the being in terms of genetics' do
      @adam.genetic_map(@expressions).should eq({:hair=>{:blond=>2, :red=>1, :pink=>1, :plaid=>1}})
    end

    it 'should be able to describe the person in visual terms' do
      @adam.description(@expressions).should eq([{:hair=>[:blond, 2]}])
    end

  end


  context 'possessions' do
    before :each do
      @thing = FactoryGirl.create :thing
      @adam.get @thing
    end

    it 'can have things' do
      @adam.things.should_not be_nil
      @adam.owns?(@thing).should be_true
    end

    it 'can lose things' do
      @adam.lose(@thing)
      @adam.owns?(@thing).should be_false
    end

    it "cannot lose things it doesn't have" do
      @adam.lose(@thing)
      lambda { @adam.lose(@thing) }.should raise_error(OwnershipException)
    end

    it 'cannot get things it already owns' do
      lambda { @adam.get(@thing) }.should raise_error(OwnershipException)
    end
  end
end
