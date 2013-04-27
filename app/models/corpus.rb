class Corpus
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :weight, type: Integer
  belongs_to :language
end
