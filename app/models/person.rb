require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', 'names.yml')))
  @@coming_of_age = 18
  @@old_age = 80
  before_create :random_gender, :random_name, :random_age
  has_and_belongs_to_many :spouses, :class_name => 'Person'
  scope :neighbors, ->(person) { where(:settlement => person.settlement) }
  scope :other_gender, ->(sex) { where(:gender.ne => sex)}
  field :surname, :type => String
  field :given_name, :type => String
  
  def self.names
    @@names
  end

  
  def marry(spouse)
    spouses << spouse
    spouse.spouses << spouse
  end
  
  def spouse 
    spouses.first
  end

  
  def married?
    not spouses.select{ |s| s.alive? }.empty?
  end
  
  def find_spouse 
    neighbors.select{ |n| n.gender != gender and not n.married? and n.age > 16}.shuffle.first
  end
  
  def name 
    [given_name, surname].join(' ')
  end

  def neighbors 
    settlement.beings.select{ |f| f != self }
  end

  def random_gender 
    unless self.gender.present?
      self.gender = ['male', 'female'].shuffle.first
    end
    true
  end
  
  def random_age
    age = Person.random_age
  end

  
  def self.random_gender
    ['male', 'female'].shuffle.first
  end

  def self.random_age
    (rand * @@old_age).floor
  end

  
  def self.random_name(gender = nil)
    gender ||= self.random_gender
    [@@names[gender].shuffle.first, @@names['surname'].shuffle.first]
  end


  def random_name
    unless self.name.present?
      self.given_name = @@names[self.gender].shuffle.first
      self.surname =  @@names['surname'].shuffle.first
      self.write_attribute(:name, name)
    end
    true
  end

end
