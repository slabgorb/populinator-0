class Settlement
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', 'settlement_names.yml')))
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
      beings << Person.create.randomize!
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
    [[top, meat, bottom].join.capitalize, (rand * 1000).floor]
  end
  
  
  def family(surname)
    beings.select{ |b| b.surname == surname }
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

  
  def seed_original_families()
    marriage = Event.where(:name => 'marriage').first || Event.new(effect:'{|a,b| a.marry b; b.surname = a.surname }', name:'marriage', description:'marriage')
    self.families.each do |family|
      family_name = family.first
      family_members = family.last
      # try to make married couples
      males = family_members.select{ |s| s.gender == 'male'}
      females = family_members.select{ |s| s.gender == 'female'}
      males.each do |m| 
        females.each do |f|
          if Person.marriage_strategy(m, f) 
            marriage.happened_to m,f
            #puts "#{m} married #{f}"
          end
        end
      end
      # now, we run through the rest of the town lookng for eligible partners
      males.each do |m|
        spouse = m.find_spouse
        marriage.happened_to m, spouse if spouse
        #puts "#{m} married #{spouse}" if spouse
      end
      # try to put the minors with families 
      minors = family_members.select{ |s| s.age < s.coming_of_age }
      minors.each do |child|
        females.select{ |s| s.married? }.try(:shuffle).try(:first).try(:beings).try(:<<, child)
      end
    end
    true
  end
end
