class Being
  include Mongoid::Document
  embeds_many :damages 
  embeds_many :things
  field :name, :type => String
  field :gender, :type => String
  field :age, :type => Fixnum
  field :alive, :type => Boolean
  
  def alive?
    alive
  end

  def dead? 
    not alive
  end

  
end


class ReproductionException < Exception
end

class DeathException < Exception
end

class OwnershipException < Exception
end
