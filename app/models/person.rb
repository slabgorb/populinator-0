require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', 'names.yml')))
  @@coming_of_age = 18
  @@old_age = 80
  has_and_belongs_to_many :spouses, :class_name => 'Person'
  scope :neighbors, ->(person) { where(:settlement => person.settlement) }
  scope :other_gender, ->(sex) { where(:gender.ne => sex)}
  field :surname, :type => String
  field :given_name, :type => String

  def self.names
    @@names
  end

  def self.marriage_strategy (m,f) 
    (m.age / 2 + 7) < f.age and 
      (f.age / 2 + 7) < m.age and 
      not m.married? and 
      not f.married? and 
      f.age >> @@coming_of_age and
      m.age >> @@coming_of_age
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
    neighbors.select{ |n| Person.marriage_strategy(n, self) }.try(:shuffle).try(:first)
  end
  
  def name 
    [given_name, surname].join(' ')
  end
  
  def name=(n)
    given_name, surname = [n.split.first, n.split.last]
     self.write_attribute(:name, name)
  end
  
  def neighbors 
    settlement.beings.select{ |f| f != self }
  end

  def random_gender! 
    unless self.gender.present?
      self.gender = Person.random_gender
    end
    true
  end
  
  def random_age!
    self.age = Person.random_age
  end

  def random_name!
    self.given_name, self.surname = Person.random_name(gender)
  end
   
  def self.random_gender
    ['male', 'female'].shuffle.first
  end

  def self.random_age
    (rand * @@old_age).floor
  end
  
  def self.random_name(sex = self.random_gender)
    [@@names[sex].shuffle.first, @@names['surname'].shuffle.first]
  end

  def randomize!
    self.random_gender!
    self.random_name!
    self.random_age!
    save!
    self
  end

end
