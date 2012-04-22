require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', 'names.yml')))
  before_create :random_gender, :random_name
  has_and_belongs_to_many :spouses, :class_name => 'Person'
  scope :neighbors, ->(person) { where(:settlement => :person.settlement) }
  field :surname, :type => String
  field :given_name, :type => String
  
  def marry(spouse)
    spouses << spouse
    spouse.spouses << spouse
  end
  
  def married?
    not spouses.select{ |s| s.alive? }.empty?
  end
  
  def find_spouse 
    Person.neighbors(self)
  end
  
  def name 
    [given_name, surname].join(' ')
  end

  
  #--------------------
  protected
  #--------------------
  def random_gender 
    unless self.gender.present?
      self.gender = ['male', 'female'].shuffle.first
    end
    true
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
