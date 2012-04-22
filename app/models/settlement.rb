class Settlement
  include Mongoid::Document
  field :name, :type => String

  has_many :beings, :dependent => :destroy   
  has_many :rulers, :dependent => :destroy
  has_many :events
  accepts_nested_attributes_for :rulers
  
  def population
    beings.length
  end
  
  def history
    events
  end
  
end
