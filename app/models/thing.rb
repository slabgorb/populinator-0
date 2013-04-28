class Thing
  include Mongoid::Document
  field :name, type: String
  belongs_to :being
  def owner 
    self.being
  end
end
