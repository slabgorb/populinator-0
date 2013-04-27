class Language
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :glossary, type: Hash
  has_many :histograms
  has_many :corpora
end
