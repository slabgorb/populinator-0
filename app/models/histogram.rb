class Histogram
  include Mongoid::Document
  belongs_to :language
  field :occurances, type: Hash
  field :name, type: String
end
