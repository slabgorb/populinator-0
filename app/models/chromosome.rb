class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :seed, :type => String
  belongs_to :being
  attr_accessor :seed

  def length 
    seed.length
  end

  def to_s
    seed
  end

  def [](index)
    seed[index] == '1'
  end

  def []=(index, value)
    seed[index] = value.to_i.to_s
  end
  
  def fitness
    seed.count('1')
  end

  def reproduce_with(other)
    genome = seed.dup
    genome.length.times do |i|
      genome[i] = rand > 0.5 ? genome[i] : other.seed[i]
    end
    seed = genome
    Chromosome.new(:seed => seed)
  end

  def mutate 
    index = (rand * length).floor
    seed[index] = seed[index] == '0' ? '1' : '0'
  end
end


