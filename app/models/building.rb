class Building
  include Mongoid::Document
  belongs_to :settlement
  has_many :residents, class_name: 'Being'
  field :description, type: String
  field :use, type: String
  field :x, type: Integer
  field :y, type: Integer
  
end
