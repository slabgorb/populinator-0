class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  @@expressions = YAML::load(File.read(File.join(Rails.root, 'genetics', 'people.yml')))
  embedded_in :being
  embeds_many :genes

  def length 
    genes.length
  end

  def <=>(other)
    other.genes.map{ |g| g.value }.sum <=> self.genes.map{ |g| g.value }.sum
  end
  
  def to_s
    genes.join(' ')
  end
  
  # creates a random set of genes
  def randomize!(genecount = 10)
    genes.delete_all
    genecount.times { self.genes << Gene.new(:code => Chromosome.rand_hex ) }
    self
  end

  def self.expressions 
    @@expressions
  end
  
  # walks through the genes and checks the genes against the
  # expression table, resulting in a hash of expressed genes.
  # for example: 
  #
  # {:hair=>{:blond=>2, :red=>1, :pink=>1, :plaid=>0}}
  #
  # This is meant to be consumed by a description engine of some kind.
  #
  def express(exps = Chromosome.expressions)
    result = { }
    self.walk do |gene| 
      exps.each_pair do |category, value|
        if value.is_a? Hash 
          result[category] = self.express(value)
        else
          matches = 0
          value.each do |expression|
            matches += 1 if gene.matches(expression)
          end
          result[category] ||= 0
          result[category] += matches
        end
      end
    end
    result
  end
  
  #
  # gene at the supplied index value
  #
  def [](index)
    genes[index].code
  end

  #
  # append a gene
  #
  def <<(gene)
    genes << gene 
  end

  
  #
  # set the gene at the supplied index value
  #
  def []=(index, value)
    genes[index].code = value if value.is_a? String and value.length == 7
  end
  
  def reproduce_with(other)
    c = Chromosome.new
    self.genes.length.times do |i|
      c.genes << ((rand > 0.5) ? self.genes[i] : other.genes[i])
    end
    c
  end

  def mutate 
    index = (rand * length).floor
    genes[index] = Chromosome.rand_hex
  end
  
  # generates a 6 digit hex number as a string
  def self.rand_hex
    ("%06x" % (rand * 16777215).floor).upcase
  end

  def walk 
    genes.each do |gene|
      yield gene
    end
  end

  
end


