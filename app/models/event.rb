class Event
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :effect, :type => String
  field :category, :type => String
  belongs_to :settlement
  belongs_to :being
  scope :disasters, where(category: 'disaster')
  scope :personal, where(category: 'personal')
  def affect(*args) 
    proc = eval("Proc.new #{self.effect}")
    proc.call(*args)
  end

  alias :happened_to :affect
  
end
