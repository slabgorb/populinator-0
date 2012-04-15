class Thing
  include Mongoid::Document
  field :name, :type => String
  embedded_in :being
  def owner 
    self.being
  end
end
