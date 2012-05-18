class Being
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  embeds_many :damages 
  has_many :things
  has_many :beings
  has_many :events
  has_many :chromosomes
  belongs_to :being
  belongs_to :settlement
  field :name, :type => String
  field :gender, :type => String, :default => nil
  field :age, :type => Fixnum, :default => 0
  field :alive, :type => Boolean, :default => true
  scope :living, -> { where(:alive => true) }
  scope :adult, -> { where(:age.gt => @@coming_of_age) }
  def to_s
    "#{name}, aged #{age}"
  end
  
  def genotype 
    chromosomes
  end
  
  def as_json(options = { })
    { :name => name, 
    :age => age,
    :alive => alive,
    :gender => gender,
      :children => beings}
  end

  
  def random_name
    unless self.name.present?
      self.given_name = %w|green red yellow black|.shuffle.first.capitalize
      self.surname = %w|dra cula franken stein were wolf shark jackal bear blob spider snake goo|.shuffle[0..((rand * 2).floor + 1)].join
      self.write_attribute(:name, name)
    end
    true
  end
  
  def alive?
    alive
  end

  def dead? 
    not alive
  end
  
  def children
    beings
  end
  
  def child_of?(other)
    not other.children.index(self).nil?
  end

  def parent_of?(other)
    not self.children.index(other).nil?
  end
  
  def sibling_of?(other)
    not self.being.beings.index(other).nil? if self.being and self.being.beings
  end
  
  def parent
    being
  end

  def hurt(damage)
    self.damages << damage
  end
  
  def hurt? 
    self.damages.length > 0
  end

  def child_sibling_of?(other)
    self.beings.select {|c| c and c.sibling_of?(other)}.length > 0
  end

  def aunt_or_uncle_of?(other)
    self.siblings.collect_concat{|s| s and s.beings}.uniq.index(other) if self.siblings
  end

  def niece_or_nephew_of?(other)
    other.aunt_or_uncle_of? self
  end
  
  def cousin_of?(other)
    self.being.siblings.collect_concat{|p| p and p.beings}.index(other) if self.being and self.being.siblings
  end
  
  def siblings
    self.being.try(:beings)
  end

  
  def heal(damage)
    self.damages.delete damage
  end
  
  def die!
    raise DeathException if dead?
    self.alive = false
    save!
  end
  

  # def relation(other) 
  #   case 
  #   when (child_of?(other) and other.gender == :male) then :father
  #   when (child_of?(other) and other.gender == :female) then :mother
  #   when (child_of?(other) and other.gender == :neuter) then :parent
  #   when (parent_of?(other) and other.gender == :neuter) then :child
  #   when (parent_of?(other) and other.gender == :female) then :daughter
  #   when (parent_of?(other) and other.gender == :male) then :son
  #   when (sibling_of?(other) and other.gender == :male) then :brother
  #   when (sibling_of?(other) and other.gender == :female) then :sister
  #   when (niece_or_nephew_of?(other) and other.gender == :male) then :uncle
  #   when (niece_or_nephew_of?(other) and other.gender == :female) then :aunt
  #   when (aunt_or_uncle_of?(other) and other.gender == :male) then :nephew
  #   when (aunt_or_uncle_of?(other) and other.gender == :female) then :niece
  #   when (cousin_of?(other)) then :cousin
  #   else 
  #     :unrelated
  #   end
  # end  
  
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
    ['male', 'female', 'neuter'].shuffle.first
  end

  
  def reproduce(other = nil, child_name = nil, child_gender = nil) 
    raise ReproductionException.new('Cannot reproduce with self unless neuter') if (other.nil? and gender != 'neuter')
    raise ReproductionException.new('Cannot reproduce with identical gender') if (other and other.gender == gender and gender != 'neuter')
    child = self.class.new(:name => child_name || 'Child of#{self.name}', :gender => child_gender || Being.random_gender, :age => 0)
    self.beings << child
    other.beings << child if other
    self.settlement.beings << child if self.settlement
    return child
  end
  
end


class ReproductionException < Exception
end

class DeathException < Exception
end

class OwnershipException < Exception
end
