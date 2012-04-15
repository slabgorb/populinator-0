class Damage
  include Mongoid::Document
  field :duration, :type => Integer
  field :description, :type => String
end
