class Settlement
  @@names = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'settlement_names.yml')))
  include Mongoid::Document
  include Mongoid::Chronology
  field :name, type: String
  field :established, type: Integer
  field :area, type: Integer
  field :icon, type: String
  field :color, type: String
  field :description, type: String
  field :initial_population, type: Integer
  has_and_belongs_to_many :languages
  has_many :residents, class_name: 'Being', dependent: :destroy
  has_many :events
  embeds_many :buildings
  accepts_nested_attributes_for :rulers
  after_create [:populate, :seed!]

  def population
    residents.living.count
  end

  def self.sizes
    { 'Hamlet' => 25,
      'Village' => 100,
      'Town' => 2500,
      'City' => 10000 }
  end

  def to_s
    name
  end

  def as_json(options = { })
    { name: name,
      established: established,
      population: population,
      families: families,
      residents: residents,
      history: history }
  end

  def populate(pop = initial_population)
    pop.to_i.times do
      p = Being.create.randomize!
      p.settlement = self
      p.events << Event.new(name: 'Parthenogenesis', description: "#{p.name} was magicked into existence.", age: p.age)
      residents << p
    end
    self
  end

  def history
    events
  end

  #
  # create a random name based on the @@names glossary of prefixes,
  # dividers, and suffixes, and being last names.
  #
  def self.random_name
    meat = Being.names['surname'].shuffle.first
    top  = rand > 0.7 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.7 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.8 ? @@names['divider'].shuffle.first : ''
    [top, meat, bottom].join.titlecase
  end

  def self.random_icon
    list = Dir.glob(File.join(Rails.root, 'app', 'assets', 'images', 'heraldry', '60', '*.png'))
    File.basename(list.shuffle.pop).gsub(/\.png/,'')
  end

  def self.random_color
    "#%06x" % (rand * 0xffffff)
  end

  def self.random
    Settlement.new(name: random_name,
                   color: random_color,
                   icon: random_icon,
                   initial_population: rand(100) + 50)
  end

  #
  # get all the residents with a particular last name
  #
  def family(surname)
    residents.all_of(surname: surname, alive: true)
  end

  def families
    Hash[family_names.map{ |m| [m, family(m)] }]
  end

  def family_names
    residents.distinct(:surname).sort
  end

  def family_populations
    Hash[family_names.map{ |m| [m, family(m).count ]}]
  end

  def marry_sets(males, females)
    married = { male: [], female: []}
    males.each do |m|
      females.each do |f|
        next if married[:male].index(m.id) or married[:female].index(f.id)
        if Being.marriage_strategy(m, f)
          m.marry f
          married[:male] << m.id
          married[:female] << f.id
        end
      end
    end
  end

  def settle(family)
    b = Building.create(use: 'residence', description: "Residence of #{family}")
    self.residents.where(surname: family).map do |m|
      b.residents << m
    end
  end

  def ruler
    residents.where(:alive => true, :title.ne => '').sort{ |a,b| a.age <=> b.age }.first
  end

  def seed!
    males = self.residents.males
    # rulers pick their spouses
    males << Being.create(settlement: self).randomize!.set_title
    females = self.residents.females
    self.marry_sets(males, females)
    minors = self.residents.children
    mothers = females.adults
    if mothers.present?
      minors.each do |child|
        begin
          mothers.select{ |s| s.age > (child.age + Being.coming_of_age) and child.age < (Being.infertility - s.age) }.shuffle.try(:first).try(:adopt, child, true)
        rescue Exception => e
          logger.error e
        end
      end
    end
    self.family_names.each do |fname|
      settle fname
    end
    self
  end

   private
   def generate_slug
     name.try(:parameterize)
   end
end
