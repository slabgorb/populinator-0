class Language
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :glossary, type: Array
  has_many :histograms
end
