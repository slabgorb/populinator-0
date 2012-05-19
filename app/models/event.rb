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
    eval("Proc.new #{self.effect}").call(*args)
    args.each do  |o| 
      o.history << self if o.respond_to? :history 
      o.save if o.respond_to? :save
    end
    
  end

  alias :happened_to :affect
  
end
