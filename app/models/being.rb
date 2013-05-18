class Being
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Chronology
  include Mongoid::Slugify

  field :name, type: String
  field :gender, type: String, default: nil
  field :age, type: Fixnum, default: 0
  field :alive, type: Boolean, default: true


  embeds_many :damages
  embeds_many :chromosomes

  has_many :things
  has_many :events

  belongs_to :settlement
  belongs_to :building

  has_and_belongs_to_many :spouses, class_name: 'Being'
  has_and_belongs_to_many :children, class_name: 'Being'
  has_and_belongs_to_many :parents, class_name: 'Being'

  scope :living, -> { where(alive: true) }
  scope :adults, -> { where(:age.gte => @@coming_of_age) }
  scope :children, ->{ where(:age.lt => @@coming_of_age )}
  scope :married, -> { where(:spouse_ids.ne => [])}
  scope :unmarried, -> { where(:spouse_ids => [])}
  scope :males, -> { where(gender: 'male')}
  scope :females, -> {  where(gender: 'female')}
  scope :orphans, -> {  where(:parent_ids => [])}
  scope :progeny, -> {  where(:parent_ids.ne => [])}
  scope :parents, -> { where(:child_ids.ne => [])}

  def to_s
    "#{name}, #{gender}, aged #{age}"
  end

  def age!(years = 1)
    Event.new(name: 'Age', description: "#{name} was magically made #{years > 0 ? ' older' : ' youthful'}.", effect: "{|b, y| b.age += y }", age: self.age + years).happened_to(self, years)
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

  ##
  # Returns the siblings of the being as the children of the parent
  # except the being
  #
  def siblings
    parents.flat_map(&:children).reject{ |r| r.id = id }
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
    end.try(:symbolize_keys)
  end

  def description(ex = nil)
    sorted_map = { }
    begin
      self.genetic_map(ex).each_pair do |trait, value|
        sorted_map[trait] = value.to_a.sort{ |a,b| b.last <=> a.last }
      end
      return sorted_map.to_a.collect { |c| { c.first => [c.second.first.first.to_sym, c.second.first.second] }}
    rescue
      []
    end
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
    spouses << s
    s.spouses << self
    events << Event.new(category: 'Personal', name: 'Marriage', description: "#{name} married #{s.name}.", age: self.age)
    s.events << Event.new(category: 'Personal', name: 'Marriage', description: "#{s.name} married #{name}.", age: s.age)
    s.update_attribute(:surname, surname) if self.respond_to?(:surname)
    s.save
    save
  end

  ##
  # Returns the first living spouse, sorted by age.
  #
  def spouse
    spouses.select{ |s| s.alive? }.sort{|a,b| a.age <=> b.age}.first
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

  ##
  # Search the neighborhood for a potential mate
  #
  def find_spouse
    neighbors.select{ |n| self.class.marriage_strategy(n, self) }.try(:shuffle).try(:first)
  end

  ##
  # Checks to see if this being has children.
  #
  def parent?
    children.present?
  end

  ##
  # Adopts a child into the family. Optionally re-sequence the
  # genetics of the child to match the parents.
  #
  def adopt(child, heredity = false)
    children << child
    if married? && spouse.children.index(child).nil?
      spouse.adopt(child, false)
    end
    if heredity
    end
    spouse.events << Event.new(name: 'Adoption', description: "adopted #{child.name}", age: spouse.age,  category: 'personal') if spouse
    events << Event.new(name: 'Adoption', description: "adopted #{child.name}", age: age,  category: 'personal')
    child.be_adopted(self, spouse)
  end

  def be_adopted(*parental_units)
    parental_units.each{ |p| parents << p }
    get_genetics!(*parental_units)
    events <<  Event.new(name: 'Adoption', description: "#{name} was adopted by #{parental_units.map(&:to_s).to_sentence}", age: age)
    update_attribute(:surname, parental_units.first.surname)
    self
  end

  ##
  # Sets the age randomly.
  #
  def random_age!
    update_attribute(:age, self.class.random_age)
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
  def random_name(sex = gender)
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
    chromosomes.delete_all
    parent1.exchange_genome(parent2).map{ |g| chromosomes << g }
    self
  end

  ##
  # Changes the name to a random name.
  #
  def random_name!
    update_attribute(:name, self.random_name.join(' '))
  end

  ##
  # Is the being alive?
  #
  def alive?
    !!alive
  end

  ##
  # Is the being dead?
  #
  def dead?
    !alive
  end

  ##
  # Is this a child of the other being?
  #
  def child_of?(other)
    not other.children.index(self).nil?
  end

  ##
  # Is this the parent of the other being?
  #
  def parent_of?(other)
    not self.children.index(other).nil?
  end

  ##
  # Is this the sibling of the other being?
  #
  def sibling_of?(other)
    self.siblings.find(other.id)
  end

  ##
  # Ow
  #
  def hurt(damage)
    self.damages << damage
  end

  ##
  # Ow?
  #
  def hurt?
    self.damages.length > 0
  end

  def child_sibling_of?(other)
    self.children.select {|c| c and c.sibling_of?(other)}.length > 0
  end

  def aunt_or_uncle_of?(other)
    parents.map(&:siblings).index(other)
  end

  def niece_or_nephew_of?(other)
    other.aunt_or_uncle_of? self
  end

  def cousin_of?(other)
    self.parents.map(&:siblings).flat_map{|p| p and p.children}.index(other) if self.parents && self.parents.reject(&:nil?).map(&:siblings)
  end

  def heal(damage)
    self.damages.delete damage
  end

  def die!
    events << Event.new(name: 'Death', description: "#{name} died.", category: 'Personal', age: self.age)
    update_attribute(:alive, false)
    self
  end

  def birth!
    events << Event.new(name: 'Birth', description: "#{name} was born", category: 'Personal',  age: self.age)
    update_attribute(:alive, true)
    self
  end

  def resurrect!
    raise DeathException if alive?
    events << Event.new(name: 'Resurrection',  category: 'Personal', description: "#{name} was resurrected.",  age: self.age)
    self
  end

  ##
  # Returns the type of relationship between two beings
  #
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

  def describe(&block)
    description.each do |tuple|
      quality = tuple.values.first.first.to_s.humanize.downcase
      next if quality =~ /not notable/
      yield(quality,
            tuple.keys.first.to_s.humanize.downcase,
            tuple.values.first.last)
    end
  end

  ##
  # Used for descriptions-
  # TODO: probably better in a helper!
  #
  def self.strength(val)
    case val
         when 0 then ['a bit', 'somewhat', 'marginally']
         when 1 then ['', '', '', 'rather']
         when 2 then ['markedly', 'noticeably', 'decidedly', 'especially']
         when 3 then ['very', 'really', 'greatly']
         when 4 then ['extremely', 'terrifically', 'tremendously']
         when 5 then ['ridiculously', 'uniquely', 'intensely']
         when 6 then ['astonishingly', 'bizarrely', 'pathologically']
    end.shuffle.first
  end

  ##
  # Used for descriptions-
  # TODO: probably better in a helper!
  #
  def bio
    out = ""
    describe do |quality, key, amount|
      # NESTED TERNARY OPERATORS ARE GOOD FOR THE CONSTITUTION
      out += [rand > 0.333 ? (gender == 'male' ? 'his' : 'her').capitalize : "#{name.split.first}'s",
               key,
               key.pluralize == key ? 'are' : 'is',
               Being.strength(amount),
               quality].join(' ') + ".\n "
    end
    out.strip
  end

  def self.random_gender
    genders.shuffle.first
  end

  def random_gender
    self.class.random_gender
  end

  def random_gender!
    update_attribute(:gender, self.class.random_gender)
  end

  def _type
    self.read_attribute(:_type)
  end

  ##
  # Neighbors selector
  #
  def neighbors
    settlement.residents.where(:id.ne => id )
  end

  ##
  # Make baby!
  #
  def reproduce(other = nil, child_name = nil, child_gender = nil)
    raise ReproductionException.new('Cannot reproduce with self unless neuter') if (other.nil? and gender != 'neuter')
    child = self.class.create
    child.get_genetics!(self, other)
    child.age = 0
    child.name = child_name || child.name
    child.gender = self.class.random_gender
    child.birth!

    # TODO: come up with a scheme to handle this more better
    child.surname = (other.gender == 'male' ? other : self).surname if child.respond_to?(:surname)
    child.given_name = child_name.split(' ').last if child.respond_to?(:given_name) and child_name

    events << Event.new(name: 'Reproduction', description: "#{name} had a child #{child.name} with #{other.try(:name)}!", age: self.age)
    other.events << Event.new(name: 'Reproduction', description: "#{other.try(:name)} had a child #{child.name} with #{name}!", age: other.age)
    children << child
    child.parents << self
    child.parents << other
    other.children << child
    self.settlement.residents << child if self.settlement
    child
  end

  alias :reproduce_with :reproduce

  def randomize!
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
