class Settlement
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'settlement_names.yml')))
  include Mongoid::Document
  field :name, :type => String
  field :established, :type => Integer
  field :area, :type => Integer
  has_many :beings, :dependent => :destroy   
  has_many :rulers, :dependent => :destroy
  has_many :events
  accepts_nested_attributes_for :rulers
  
  def population
    beings.select{ |c| c.alive? }.length + rulers.select{ |c| c.alive? }.length
  end

  def self.sizes 
    { 
      'Hamlet' => 25,
      'Village' => 100,
      'Town' => 2500,
      'City' => 10000
    }  
  end
    
  def as_json(options = { })
    { name: name, 
      established: established, 
      population: population,
      ruler: rulers.first,   
      families: families,
      residents: beings,
      history: history
    }
  end
  
  def populate(pop)
    pop.to_i.times do
      p = Person.create.randomize!
      p.settlement = self
      beings << p
    end
    save
  end

  def history
    events
  end
  
  def self.random_name
    meat = Person.names['surname'].shuffle.first
    top  = rand > 0.5 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.5 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.7 ? @@names['divider'].shuffle.first : ''
    [top, meat, bottom].join.capitalize
  end
  
  
  def family(surname)
    beings.select{ |b| b.surname == surname }.keep_if{ |f| not (f.gender == 'female' and f.married?) }
  end
  
  def families
    Hash[*family_names.sort.collect{ |s| [s, self.family(s)] }.flatten(1)]
  end

  def family_names
    beings.collect{ |b| b.surname }.uniq.select{ |b| b }
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
    marriage = Event.where(:name => 'marriage').first || Event.new(effect:'{|a,b| a.marry b; b.surname = a.surname }', name:'marriage', description:'marriage')
    marriage.happened_to male, female
  end

  
  def seed_original_families()
    males = self.beings.select{ |s| s.gender == 'male'}
    females = self.beings.select{ |s| s.gender == 'female'}  
    self.marry_sets(males, females)
    minors = self.beings.select{ |s| s.age < s.coming_of_age }
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
    true
  end
end
