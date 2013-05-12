class Event
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :effect, type: String
  field :year, type: Integer
  field :category, type: String
  field :age, type: Integer
  belongs_to :settlement
  belongs_to :being
  scope :disasters, where(category: 'disaster')
  scope :personal, where(category: 'personal')

  def to_s
    "#{self.name} #{self.description}"
  end

end
