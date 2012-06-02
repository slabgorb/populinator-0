class Gene
  include Mongoid::Document
  embedded_in :chromosome
  field :code, type:String
  
  def matches(expression)
    self.code =~ expression
  end

  
end
