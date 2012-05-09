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

  def self.random_name
    meat = Person.names['surname'].shuffle.first
    top  = rand > 0.5 ? @@names['prefix'].shuffle.first : ''
    bottom = rand > 0.5 ? @@names['suffix'].shuffle.first : ''
    top += rand > 0.7 ? @@names['divider'].shuffle.first : ''
    [[top, meat, bottom].join.capitalize, (rand * 1000).floor]
  end
end
