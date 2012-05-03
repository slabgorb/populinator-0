class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  belongs_to :being
  
  
  attr_accessor :seed

  def initialize(seed)
    @seed = seed
  end

  def fitness
    @seed.count('F')
  end

  def reproduce(other)
    genome = seed.dup
    genome.length.times do |i|
      genome[i] = rand > 0.5 ? genome[i] : other.seed[i]
    end
    seed = genome
    save
  end

  def mutate 
    seed[floor(rand * seed.count)] = %w|A B C D E F|.shuffle.first
  end
end

class Gene
  attr_accessor :score
  attr_reader :length, :answers

  def initialize(length)
    @length = length
    @answers = Array.new(@length) { rand(3) }
  end

  def [](index)
    @answers[index]
  end

  def []=(index, value)
    @answers[index] = value
  end

  def to_s
    "[" + @answers.join(',') + "]"
  end
end
