require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'names.yml')))
  @@coming_of_age = 18
  @@old_age = 80
  @@infertilty = 50

  scope :neighbors, ->(person) { where(:settlement => person.settlement) }
  scope :other_gender, ->(sex) { where(:gender.ne => sex)}
  field :surname, :type => String
  field :given_name, :type => String


  def self.names
    @@names
  end

  def self.infertility
    @@infertilty
  end
  def self.coming_of_age
    @@coming_of_age
  end
  
  def self.genders
    ['male', 'female']
  end
  
  def self.marriage_strategy (m,f) 
    (m.age / 2 + 7) < f.age and 
      (f.age / 2 + 7) < m.age and 
      not m.married? and 
      not f.married? and 
      not f.gender == m.gender and
      f.age > @@coming_of_age and
      m.age > @@coming_of_age
  end

  def name 
    [self.given_name, self.surname].join(' ')
  end
  
  def name=(n)
    given_name, surname = [n.split.first, n.split.last]
     self.write_attribute(:name, name)
  end
  


  def self.genders
    ['male', 'female']
  end
  
  def random_age!
    self.age = Person.random_age
  end

  def random_name!
    self.given_name, self.surname = self.class.random_name(gender)
  end
   

  def self.random_age
    (rand * @@old_age).floor
  end
  
  def self.random_name(sex = self.random_gender)
    surname = @@names['surname'].shuffle.first
    given_name = @@names[sex].shuffle.first
    [given_name, surname].join(' ')
  end
end
