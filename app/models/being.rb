class Being
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  embeds_many :damages 
  has_many :things
  has_many :children, :class_name => 'Being'
  has_many :events
  has_many :chromosomes
  belongs_to :parent, :class_name => 'Being'
  belongs_to :settlement
  field :name, :type => String
  field :gender, :type => String, :default => nil
  field :age, :type => Fixnum, :default => 0
  field :alive, :type => Boolean, :default => true
  scope :living, -> { where(:alive => true) }
  scope :adult, -> { where(:age.gt => @@coming_of_age) }
  has_and_belongs_to_many :spouses, :class_name => 'Being'
  
  def to_s
    "#{name}, aged #{age}"
  end
  
  @@coming_of_age = 1
  
  def genotype 
    chromosomes
  end
  
  def genetic_map
    self.genotype.map{|g| g.express }.inject{ |m, g| m.merge(g){ |k, original_value, new_value| original_value.merge(new_value){ |kp, original_value_prime, new_value_prime| [original_value_prime, new_value_prime].max } } }.symbolize_keys
  end
  
  def description
    retval = { }
    self.genetic_map.each_pair do |trait, value|
      retval[trait] = value.to_a.sort{ |a,b| b.last <=> a.last } 
    end
    retval
  end
  
  def as_json(options = { })
    super(only:[:id, :name, :age, :alive, :_type],
          methods: [:children, :married?,:spouse_id])
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

  def self.random_gender
    self.genders.shuffle.first
  end

  
  def marry(s)
    self.spouses.push(s) if s
    s.spouses.push(self) if s.respond_to? :spouses
  end
  
  def spouse 
    self.spouses.select{ |s| s.alive? }.first
  end

  def spouse_id
    spouse.id if spouse
  end
  
  def married?
    spouse.present?
  end
  
  def find_spouse 
    self.neighbors.select{ |n| Person.marriage_strategy(n, self) }.try(:shuffle).try(:first)
  end
  
  def adopt(child)
    self.children << child
    child.surname = self.surname
    child.parent = self
    child.save
    save
    child
  end
  
  def self.random_name(sex = self.random_gender)
    [%w|green red yellow black|.shuffle.first.capitalize,
     %w|dra cula franken stein were wolf shark jackal bear blob spider snake goo|.shuffle[0..((rand * 2).floor + 1)].join]
  end

  
  def random_name!
    self.given_name, self.surname = self.random_name
    self.write_attribute(:name, [self.given_name, self.surname].join(' '))
    true
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
    not self.parent.children.index(other).nil? if self.parent and self.parent.children
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
  
  def siblings
    self.parent.try(:children)
  end

  
  def heal(damage)
    self.damages.delete damage
  end
  
  def die!
    raise DeathException if dead?
    self.alive = false
    save!
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
    raise ReproductionException.new('Cannot reproduce with identical gender') if (other and other.gender == gender and gender != 'neuter')
    child = self.class.new(name: child_name || 'Child of#{self.name}', gender: child_gender || Being.random_gender, age: 0)
    self.children << child
    other.children << child if other
    self.settlement.beings << child if self.settlement
    return child
  end
  
   def randomize!
     12.times { self.chromosomes <<  Chromosome.new.randomize! }
     self.random_gender!
     self.random_name!
     self.random_age!
     self
  end
end


class ReproductionException < Exception
end

class DeathException < Exception
end

class OwnershipException < Exception
end
