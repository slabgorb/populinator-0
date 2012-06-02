class Settlement
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'settlement_names.yml')))
  include Mongoid::Document
  field :name, :type => String
  field :established, :type => Integer
  field :area, :type => Integer
  has_many :residents, :class_name => 'Being', :dependent => :destroy   
  has_many :rulers, :class_name => 'Being', :dependent => :destroy
  has_many :events
  accepts_nested_attributes_for :rulers
  
  def population
    residents.select{ |c| c.alive? }.length + rulers.select{ |c| c.alive? }.length
  end
  
  def self.sizes 
    { 'Hamlet' => 25,
      'Village' => 100,
      'Town' => 2500,
      'City' => 10000 }  
  end
    
  def as_json(options = { })
    { name: name, 
      established: established, 
      population: population,
      ruler: rulers.first,   
      families: families,
      residents: residents,
      history: history }
  end
  
  def populate(pop)
    pop.to_i.times do
      p = Person.create
      p.randomize!
      p.settlement = self
      residents << p
    end
    save
  end

  def history
    events
  end
  
  def self.random_name
    meat = Person.names['surname'].shuffle.first
    top  = rand > 0.7 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.7 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.8 ? @@names['divider'].shuffle.first : ''
    [top, meat, bottom].join.capitalize
  end

  def family(surname)
    residents.select{ |b| b.surname == surname }.keep_if{ |f| not (f.gender == 'female' and f.married?) }
  end
  
  def families
    Hash[*family_names.sort.collect{ |s| [s, self.family(s)] }.flatten(1)]
  end

  def family_names
    residents.collect{ |b| b.surname }.uniq.select{ |b| b }
  end
  
  def family_populations
    Hash[*family_names.inject([]){|n,f| n << [f, family(f).count] }.flatten]
  end

  def marry_sets(males, females)
    males.each do |m| 
      females.each do |f|
        if Person.marriage_strategy(m, f) 
          marry_one(m,f)
        end
      end
    end    
  end
  
  def marry_one(male, female)
    marriage = Event.new(effect:'{|a,b| a.marry b; b.surname = a.surname }', name:'marriage', description:'Got married')
    marriage.happened_to male, female
    female.surname = male.surname
  end

  def ruler 
    self.rulers.select { |s| s.alive? }.sort{ |a,b| b.age <=> a.age }.first
  end
    
  def seed!
    self.rulers << Person.create.randomize!
    males = self.residents.select { |s| s.gender == 'male' }
    females = self.residents.select { |s| s.gender == 'female' }
    self.marry_sets(males, females)
    minors = self.residents.select{ |s| s.age < s.coming_of_age }
    mothers = females.select{ |s| s.married? and s.age < Person.infertility}
    if mothers.present?
      minors.each do |child|
        child.settlement = self
        child.save!
        begin
          mothers.select{ |s| s.age > (child.age + Person.coming_of_age) and child.age < (Person.infertility - s.age) }.shuffle.first.adopt child
        rescue Exception => e
          logger.error e
        end
      end
    end
    minors.each do |minor|
      minor.surname = minor.parent.surname if minor.parent
      minor.save
    end
    males.each do |person|
      person.spouse.surname = person.surname if person.spouse
      person.save
    end
    true
  end
end
