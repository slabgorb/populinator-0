require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', 'names.yml')))
  before_create :random_gender, :random_name
  has_and_belongs_to_many :spouses, :class_name => 'Person'
  
  def marry(spouse)
    spouses << spouse
    spouse.spouses << spouse
  end
  
  def married?
    not spouses.select{ |s| s.alive? }.empty?
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
      self.name = [@@names[self.gender].shuffle.first, @@names['surname'].shuffle.first].join(' ')
    end
    true
  end
end

