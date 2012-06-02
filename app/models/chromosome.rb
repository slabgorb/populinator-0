class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  @@expressions = YAML::load(File.read(File.join(Rails.root, 'genetics', 'people.yml')))
  belongs_to :being
  embeds_many :genes

  def length 
    genes.length
  end

  def to_s
    genes.join(' ')
  end

  def expressions
    @@expressions
  end
  
  def express
    exp = []
    self.walk do |gene| 
      expressions.each_pair do |category, value|
        value.each do |expression|
          matches = gene.matches(expression)
          if matches.try(:length).try(:>, 0)
            exp << { match: matches.first, heading: heading, category: category }
          end
        end
      end
    end
    exp
  end
  
  def [](index)
    genes[index].code
  end

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
  
  # generates a 7 digit hex number as a string
  def self.rand_hex
    ("%07x" % (rand * 268435455).floor).upcase
  end

  def walk 
    genes.each do |gene|
      yield gene
    end
  end

  
end


