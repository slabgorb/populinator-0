class Event
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :effect, :type => String
  belongs_to :settlement
  belongs_to :being
  
  def affect(*args) 
    proc = eval("Proc.new #{self.effect}")
    proc.call(*args)
  end

  alias :happened_to :affect
  
end
