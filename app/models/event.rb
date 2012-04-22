class Event
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :occurred_on, :type => String
  field :effect, :type => String
  belongs_to :settlement
  belongs_to :being
end
