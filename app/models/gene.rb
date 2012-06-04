class Gene
  include Mongoid::Document
  embedded_in :chromosome
  field :code, type:String
  
  def to_s
    self.code
  end

  def <=>(other)
    other.code <=> self.code
  end
  
  def matches(expression)
    self.code =~ /#{expression}/
  end

  def value 
    self.code.to_i(16)
  end
end
