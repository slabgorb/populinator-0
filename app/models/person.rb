require 'yaml'
class Person < Being
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'names.yml')))
  @@coming_of_age = 18
  @@old_age = 80
  @@infertilty = 50
  @@description = 'A generic person'

  scope :from, ->(settlement) { where(settlement_id: settlement.id) }
  scope :neighbors, ->(person) { where(settlement_id: person.settlement_id) }
  scope :other_gender, ->(sex) { where(:gender.ne => sex)}
  scope :family_members, ->(name) {  where(surname: name) }
  field :surname, type: String
  field :given_name, type: String
  field :title, type: String
  @@titles = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'titles.yml')))


  before_update lambda{ name = [given_name, surname].join(' ') }

  def set_title
    unless self.title.present?
      if self.settlement.present?
        pop = settlement.population
        @@titles.each{ |k,v| self.title = v.capitalize if k < pop }
        self.title = @@titles.to_a.last unless self.title.present?
      end
      save
    end
    self
  end

  def self.names
    @@names
  end

  def family_name
    surname || name.try(:split).try(:last) || id
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
      # not f.sibling_of? m and
      # not f.aunt_or_uncle_of? m and
      # not f.niece_or_nephew_of? m and
      # not f.cousin_of? m
      f.age > @@coming_of_age and
      m.age > @@coming_of_age
  end

  def name
    [self.given_name, self.surname].join(' ')
  end

  ##
  # Overrides the Being#reproduce method.
  #
  def reproduce(other = nil, child_name = nil, child_gender = nil)
    child = super
    sex = random_gender
    child.update_attributes({  gender:sex, given_name:@@names[sex].shuffle.first })
    child
  end

  ##
  # Change the name.
  #
  def random_name!
    name = self.class.random_name(gender)
    update_attributes({ surname:name.last, given_name:name.first })
  end

  ##
  # Return a random name based on the gender of the being- names are
  # loaded from a file.
  #
  def self.random_name(sex = self.random_gender)
    [@@names['surname'].shuffle.first, @@names[sex].shuffle.first]
  end
end
