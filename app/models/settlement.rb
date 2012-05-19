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
    { :name => name, 
      :established => established, 
      :population => population,
      :ruler => rulers.first,   
      :families => self.families.each { |f| Hash.new(f, self.family(f)) },
      :residents => beings.sort{ |a,b| a.surname <=> b.surname }
    }
  end
  
  def populate(population)
    population.to_i.times do
      beings << Person.create.randomize!
    end
    save
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
    beings.collect{ |b| b.surname }.uniq
  end

  
  def seed_original_families(marriage = Event.where(:name => 'marriage').first)
    self.families.each do |family_name|
      family_members = family family_name
      # try to make married couples
      males = family_members.select{ |s| s.gender == 'male'}
      females = family_members.select{ |s| s.gender == 'female'}
      males.each do |m| 
        females.each do |f|
          if Person.marriage_strategy(m, f) 
            marriage.happened_to m,f
          end
        end
      end
      # now, we run through the rest of the town lookng for eligible partners
      males.each do |m|
        spouse = m.find_spouse
        marriage.happened_to m, spouse if spouse
      end

      # try to put the minors with families 
      minors = family_members.select{ |s| s.age < s.coming_of_age }
      minors.each do |child|
        females.select{ |s| s.married? }.try(:shuffle).try(:first).try(:beings).try(:<<, child)
      end
    end
  end
end
