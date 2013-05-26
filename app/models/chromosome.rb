class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  @@expressions = YAML::load(File.read(File.join(Rails.root, 'genetics', 'people.yml')))
  embedded_in :being
  field :genes, type: Array, default: []
  index({ genes: 1 })

  #
  # Compare operator - compare the base 10 values
  # @see value
  # @param other Chromosome
  def <=>(other)
    other.value <=> value
  end

  def to_s
    genes.join(' ')
  end

  #
  # Calculates the sum of base 10 values for the array of genes.
  #
  def value
    genes.inject(0){ |memo, g| memo += g.to_i(16) }
  end


  # creates a random set of genes
  def randomize!(genecount = 10)
    genecount.times.each { self << Chromosome.rand_hex  }
    self
  end

  def self.expressions
    @@expressions
  end

  # to integer
  def to_i(index)
    self.genes.inject(0){ |memo, gene| memo += gene.to_i(16)}
  end

  # walks through the genes and checks the genes against the
  # expression table, resulting in a hash of expressed genes.
  # for example:
  #
  # {:hair=>{:blond=>2, :red=>1, :pink=>1, :plaid=>0}}
  #
  # This is meant to be consumed by a description engine of some kind.
  #
  def express(exps = Chromosome.expressions, set = genes.join )
    result = { }
    exps.each_pair do |category, value|
      if value.is_a? Hash
        result[category] = self.express(value, set)
      elsif value.is_a? Array
        matches = 0
        position = 0
        value.each do |expression|
          while position
            position = set.index(expression, position + 1)
            matches += 1 if position
          end
        end
        result[category] ||= 0
        result[category] += matches
      end
    end
    result
  end

  #
  # gene at the supplied index value
  #
  def [](index)
    genes[index]
  end

  #
  # append a gene
  #
  def <<(gene)
    genes << gene
  end

  #
  # length represents the length of the gene array.
  #
  def length
    genes.length
  end


  #
  # set the gene at the supplied index value
  #
  def []=(index, value)
    genes[index] = value
  end

  #
  # Exchange genetic material with another chromosome. The strategy is
  # to loop through the gene arrays of this and the other chromosome
  # and randomly exchange at the gene level
  #
  def reproduce_with(other)
    c = Chromosome.new
    self.length.times do |i|
      c  << ((rand > 0.5) ? self[i] : other[i])
    end
    c
  end

  #
  # Change one of the genes to a random value.
  #
  def mutate
    index = (rand * length).floor
    genes[index] = Chromosome.rand_hex
  end

  #
  # generates a 6 digit hex number as a string
  #
  def self.rand_hex
    ("%06x" % (rand * 16777215).floor).upcase
  end

  def walk
    genes.each do |gene|
      yield gene
    end
  end


end


