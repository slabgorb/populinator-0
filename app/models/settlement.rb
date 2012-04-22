class Settlement
  include Mongoid::Document
  field :name, :type => String

  has_many :beings
  has_many :rulers 
  accepts_nested_attributes_for :rulers
  
  def population
    beings.length
  end
  
  
end
