class Chromosome
  attr_accessor :seed

  def initialize(seed)
    @seed = seed
  end

  def fitness
    @seed.count('F')
  end

  def reproduce(other)
    seed.length.times do |i|
      seed[i] = rand > 0.5 ? seed[i] : other.seed[i]
    end
  end

  def mutate 
    seed[floor(rand * seed.count)] = %w|A B C D E F|.shuffle.first
  end
end
