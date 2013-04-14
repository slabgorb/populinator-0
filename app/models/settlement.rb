class Settlement
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'settlement_names.yml')))
  include Mongoid::Document
  include Mongoid::Chronology
  field :name, :type => String
  field :established, :type => Integer
  field :area, :type => Integer
  has_many :residents, :class_name => 'Being', :dependent => :destroy   
  has_many :events
  embeds_many :buildings
  accepts_nested_attributes_for :rulers
  
  
  def population
    residents.living.count
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
      p = Person.create.randomize!
      p.settlement = self
      p.events << Event.new(:name => 'Parthenogenesis', :description => "#{p.name} was magicked into existence.", :age => p.age)
      residents << p
    end
  end

  def history
    events
  end
  
  # 
  # create a random name based on the @@names glossary of prefixes,
  # dividers, and suffixes, and person last names.
  #
  def self.random_name
    meat = Person.names['surname'].shuffle.first
    top  = rand > 0.7 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.7 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.8 ? @@names['divider'].shuffle.first : ''
    [top, meat, bottom].join.titlecase
  end

  #
  # get all the residents with a particular last name
  #
  def family(surname)
    residents.family(surname)
  end
  
  def families
    Hash[*family_names.sort.collect{ |s| [s, family(s)] }.flatten(1)]
  end

  def family_names
    residents.distinct(:surname)
  end
  
  def family_populations
    Hash[*family_names.inject([]){|n,f| n << [f, family(f).count] }.flatten]
  end

  def marry_sets(males, females)
    cache = { :male => [], :female => []}
    males.each do |m| 
      females.each do |f|
        next if cache[:male].index(m.id) or cache[:female].index(f.id) 
        if Person.marriage_strategy(m, f) 
          m.marry f
          cache[:male] << m.id
          cache[:female] << f.id
        end
      end
    end    
  end
  
  def settle(family)
    b = Building.create(use: 'residence', description: "Residence of #{family}") 
    self.residents.where(:surname => family).map do |m| 
      b.residents << m
    end
  end

  
  def ruler 
    self.residents.select { |s| s.alive? and s.is_a?(Ruler) }.sort{ |a,b| b.age <=> a.age }.first
  end
    
  def seed!
    self.residents << Ruler.create(settlement: self).randomize!
    males = self.residents.select { |s| s.gender == 'male' }
    males << ruler # rulers pick their spouses
    females = self.residents.select { |s| s.gender == 'female' }
    self.marry_sets(males, females)
    minors = self.residents.select{ |s| s.age < s.coming_of_age and not s.parent }
    mothers = females.select{ |s| s.married? and s.age < Person.infertility}
    if mothers.present?
      minors.each do |child|
        begin
          mothers.select{ |s| s.age > (child.age + Person.coming_of_age) and child.age < (Person.infertility - s.age) }.shuffle.try(:first).try(:adopt, child, true)
        rescue Exception => e
          logger.error e
        end
      end
    end
    self.family_names.each do |fname|
      settle fname
    end
    true
  end
  
   private
   def generate_slug
     name.try(:parameterize)
   end     
end
