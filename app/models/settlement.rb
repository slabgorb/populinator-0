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
    beings.select{ |c| c.alive? }.length
  end

  def as_json(options = { })
    { :name => name, 
      :established => established, 
      :population => population,
      :ruler => rulers.first,   
  

      :residents => beings.sort{ |a,b| a.surname <=> b.surname } }
  end

  
  def self.random_name
    meat = Person.names['surname'].shuffle.first
    top  = rand > 0.5 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.5 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.7 ? @@names['divider'].shuffle.first : ''
    [[top, meat, bottom].join.capitalize, (rand * 1000).floor]
  end
  
  def seed_original_families
    beings.collect{ |b| b.surname }.uniq.each do |name|
      family_members = beings.select{ |s| s.surname == name }
      # try to make married couples
      males = family_members.select{ |s| s.gender == 'male'}
      females = family_members.select{ |s| s.gender == 'female'}
      marriage = Event.where(:name => 'marriage').first
      males.each do |m| 
        females.each do |f|
          if Person.marriage_strategy(m, f) 
            marriage.happened_to m,f
          end
        end
      end
    end
  end
end
