class Being
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Acts::Tree
  include Mongoid::Chronology
  include Mongoid::Slugify
  #include Mongoid::Slug

  
  field :name, :type => String
  field :gender, :type => String, :default => nil
  field :age, :type => Fixnum, :default => 0
  field :alive, :type => Boolean, :default => true
  
  acts_as_tree order:[['age', 'desc']]

  embeds_many :damages 
  embeds_many :chromosomes
  
  has_many :things
  has_many :events
  
  belongs_to :settlement
  belongs_to :building
  
  has_and_belongs_to_many :spouses, :class_name => 'Being'

  scope :living, -> { where(:alive => true) }
  scope :adult, -> { where(:age.gt => @@coming_of_age) }
  
  def to_s
    "#{name}, aged #{age}"
  end
  
  def age!(years = 1)
    Event.new(:name => 'Age', :description => "#{name} was magically made #{years > 0 ? ' older' : ' youthful'}.", :effect => "{|b, y| b.age += y }", age: self.age + years).happened_to(self, years)
    save
    self.age
  end

  
  @@coming_of_age = 1
  @@old_age = 80
  @@infertilty = 50
  
  def genotype 
    chromosomes.sort
  end

  def self.old_age
    @@old_age
  end

  
  def self.infertility
    @@infertilty 
  end
  
  def self.coming_of_age
    @@coming_of_age
  end
  
  def exchange_genome(other)
    g_self = genotype
    g_other = other.genotype
    g_out = []
    g_self.count.times do |i|
      g_out << g_self[i].reproduce_with(g_other[i])
    end
    g_out
  end
  
  def genetic_map(ex = nil)
    ex ||= Chromosome.expressions 
    self.genotype.map{ |g| g.express(ex) }.inject do |m, g| 
      m.merge(g) do |k, original_value, new_value| 
        original_value.merge(new_value){ |kp, original_value_prime, new_value_prime| [original_value_prime, new_value_prime].max } 
      end
    end.symbolize_keys
  end
  
  def description(ex = nil)
    sorted_map = { }
    self.genetic_map(ex).each_pair do |trait, value|
      sorted_map[trait] = value.to_a.sort{ |a,b| b.last <=> a.last } 
    end
    sorted_map.to_a.collect { |c| { c.first => [c.second.first.first.to_sym, c.second.first.second] }}
  end
  
  def as_json(options = { })
    super(only:[:id, :name, :age, :alive, :_type],
          methods: [:children, :married?,:spouse_id, :history])
  end

  def coming_of_age
    @@coming_of_age
  end

  def history
    events
  end

  def self.genders
    ['male', 'female', 'neuter']
  end

  ##
  # Returns a random gender from the set of available genders.
  #
  def self.random_gender
    self.genders.shuffle.first
  end

  ##
  # Marry another being.
  #
  def marry(s)
    self.spouses << s
    s.spouses << self
    e = Event.new(:name => 'Marriage', :description => "#{name} married #{s.name}.", :age => self.age)
    e.happened_to(self, s)
    s.surname = self.surname if self.respond_to?(:surname)
    e.happened_to(s, self)
    s.save
    save
  end
  
  ##
  # Returns the first living spouse, sorted by age.
  #
  def spouse 
    self.spouses.select{ |s| s.alive? }.sort{|a,b| a.age <=> b.age}.first
  end
  
  ##
  # Returns the id of the first living spouse. 
  # @see spouse
  #
  def spouse_id
    spouse.id if spouse
  end
  
  def married?
    spouse.present?
  end
  
  def find_spouse 
    self.neighbors.select{ |n| Person.marriage_strategy(n, self) }.try(:shuffle).try(:first)
  end
  
  ##
  # Adopts a child into the family. Optionally re-sequence the
  # genetics of the child to match the parents.
  #
  def adopt(child, heredity = false)
    self.children << child
    child.surname = self.surname if child.respond_to?(:surname)
    child.save
    if heredity 
      child.get_genetics!(child.parent, child.parent.spouse)
    end
    e = Event.new(:name => 'Adoption', :description => "#{child.name} was adopted by #{name}", age: child.age)
    e.happened_to(child)
    e = Event.new(:name => 'Adoption', :description => "#{child.name} was adopted", age: lambda { self.age })
    e.happened_to(self)
    e.happened_to(self.spouse)
    child.save
    child
  end

  ##
  # Sets the age randomly.
  #
  def random_age!
    self.age = self.class.random_age
  end


  ## 
  # Returns a random name.
  # 
  # = Example
  #    Being.random_name('male')
  # > Greendrastein
  #   
  def self.random_name(sex = self.random_gender)
    [%w|green red yellow black|.shuffle.first.capitalize,
     %w|dra cula franken stein were wolf shark jackal bear blob spider snake goo|.shuffle[0..((rand * 2).floor + 1)].join.titlecase]
  end
  
  ## 
  # Instance level copy of Being.random_name
  #
  def random_name(sex = self.gender)
    self.class.random_name(sex)
  end

  ## 
  # Returns a random age.
  #
  def self.random_age
    (rand * @@old_age).floor
  end
    
  ##
  # Sets the genetics to be an inheritance from the two parents.
  #
  def get_genetics!(parent1, parent2)
    self.chromosomes.delete_all
    parent1.exchange_genome(parent2).map{ |g| self.chromosomes << g }   
    self
  end
  
  ## 
  # Changes the name to a random name.
  #
  def random_name!
    self.name = self.random_name.join(' ')
  end
  
  def alive?
    alive
  end

  def dead? 
    not alive
  end
  
  def child_of?(other)
    not other.children.index(self).nil?
  end

  def parent_of?(other)
    not self.children.index(other).nil?
  end
  
  def sibling_of?(other)
    self.siblings.find(other.id)
  end
  
  def hurt(damage)
    self.damages << damage
  end
  
  def hurt? 
    self.damages.length > 0
  end

  def child_sibling_of?(other)
    self.children.select {|c| c and c.sibling_of?(other)}.length > 0
  end

  def aunt_or_uncle_of?(other)
    self.siblings.collect_concat{|s| s and s.children}.uniq.index(other) if self.siblings
  end

  def niece_or_nephew_of?(other)
    other.aunt_or_uncle_of? self
  end
  
  def cousin_of?(other)
    self.parent.siblings.collect_concat{|p| p and p.children}.index(other) if self.parent and self.parent.siblings
  end
  
  def heal(damage)
    self.damages.delete damage
  end
  
  def die!
    raise DeathException if dead?
    Event.new(:name => 'Death', :description => "#{name} died.", :effect => "{|b| b.alive = false; b.save }", age: self.age).happened_to(self)
    self
  end
  
  def birth!
    Event.new(:name => 'Birth', :description => "#{name} was born", :effect => "{|b| b.alive = true; b.save }", age: self.age).happened_to(self)
    self
  end
  
  def resurrect!
    raise DeathException if alive?
    Event.new(:name => 'Resurrection', :description => "#{name} was resurrected.", :effect => "{|b| b.alive = true; b.save }", age: self.age).happened_to(self)
  end
  

  def relation(other) 
    case 
    when (child_of?(other) and other.gender == :male) then :father
    when (child_of?(other) and other.gender == :female) then :mother
    when (child_of?(other) and other.gender == :neuter) then :parent
    when (parent_of?(other) and other.gender == :neuter) then :child
    when (parent_of?(other) and other.gender == :female) then :daughter
    when (parent_of?(other) and other.gender == :male) then :son
    when (sibling_of?(other) and other.gender == :male) then :brother
    when (sibling_of?(other) and other.gender == :female) then :sister
    when (niece_or_nephew_of?(other) and other.gender == :male) then :uncle
    when (niece_or_nephew_of?(other) and other.gender == :female) then :aunt
    when (aunt_or_uncle_of?(other) and other.gender == :male) then :nephew
    when (aunt_or_uncle_of?(other) and other.gender == :female) then :niece
    when (cousin_of?(other)) then :cousin
    else 
      :unrelated
    end
  end  
  
  def get(thing)
    raise OwnershipException if owns?(thing)
    self.things << thing
  end

  def owns?(thing)
    not self.things.index(thing).nil?
  end
  
  def lose(thing)
    raise OwnershipException unless owns?(thing)
    self.things.delete thing
  end
  
  
  def self.random_gender
    genders.shuffle.first
  end
  
  def random_gender
    self.class.random_gender
  end
  
  def random_gender! 
    self.gender = random_gender
  end
  
  def _type 
    self.read_attribute(:_type)
  end
  
  def neighbors 
    settlement.beings.select{ |f| f != self }
  end
  
  def reproduce(other = nil, child_name = nil, child_gender = nil) 
    raise ReproductionException.new('Cannot reproduce with self unless neuter') if (other.nil? and gender != 'neuter')
    #raise ReproductionException.new('Cannot reproduce with identical gender') if (other and other.gender == gender and gender != 'neuter')
    child = self.class.create
    child.get_genetics!(self, other)
    child.age = 0
    child.name = child_name || child.name
    child.birth! 
    
    # TODO: come up with a scheme to handle this more better
    child.surname = (other.gender == 'male' ? other : self).surname if child.respond_to?(:surname)
    child.given_name = child_name.split(' ').last if child.respond_to?(:given_name) and child_name
    
    Event.new(:name => 'Reproduction', :description => "#{name} had a child #{child.name} with #{other.try(:name)}!", :age => self.age).happened_to(self)
    Event.new(:name => 'Reproduction', :description => "#{other.try(:name)} had a child #{child.name} with #{name}!", :age => other.age).happened_to(other) if other
    self.children << child
    self.settlement.residents << child if self.settlement
    child
  end
  
  alias :reproduce_with :reproduce
  
  def randomize!
    Rails.logger.debug '*' * 80
    Rails.logger.debug 'in randomize'
    Rails.logger.debug '*' * 80
    10.times { self.chromosomes <<  Chromosome.new.randomize! }
    self.random_gender!
    self.random_name!
    self.random_age!
    self
  end

  alias :randomize :randomize!

   private
   def generate_slug
     name.try(:parameterize) || self.class.to_s
   end   
   
end


class ReproductionException < Exception
end

class DeathException < Exception
end

class OwnershipException < Exception
end
