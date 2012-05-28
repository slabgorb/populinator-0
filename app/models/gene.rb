class Gene
  include Mongoid::Document
  embedded_in :chromosome
  field :code, type:String
end
