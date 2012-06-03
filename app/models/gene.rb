class Gene
  include Mongoid::Document
  embedded_in :chromosome
  field :code, type:String
  
  def to_s
    self.code
  end

  
  def matches(expression)
    self.code =~ /#{expression}/
  end

  
end
