module StringExtensions
  def possessive
    self + ('s' == self[-1,1] ? "'" : "'s")
  end
end

class String
  include StringExtensions
end

module BeingsHelper
  
  ## 
  # Returns a random adjective based on the intensity 
  #
  def strength(tuple)
    case tuple.values.first.last
         when 0 then ['']
         when 1 then ['a bit', 'somewhat', 'rather']
         when 2 then ['markedly', 'noticeably', 'decidedly', 'especially']
         when 3 then ['very', 'really', 'greatly']
         when 4 then ['extremely', 'terrifically', 'tremendously']
         when 5 then ['ridiculously', 'uniquely', 'intensely']
         when 6 then ['astonishingly', 'bizarrely', 'pathologically']
    end.shuffle.first
  end

  ##
  # Gender specific possessive 
  #
  def possessive_pronoun(being)
    case being.gender
      when 'male' then 'his'
      when 'female' then 'her'
      when 'neuter' then 'its'
    end
  end

  ##
  # Provides a description based on the genetics of the being.
  #
  def describe(being)
    desc = ''
    being.description.each do |tuple|
      quality = tuple.values.first.first.to_s.humanize.downcase
      next if quality =~ /not notable/
      key = tuple.keys.first.to_s.humanize.downcase
      desc += [rand > 0.333 ? possessive_pronoun(being).capitalize : being.name.split.first.possessive,
               key,
               key.pluralize == key ? 'are' : 'is', 
               strength(tuple),
               quality].join(' ') + '. '
    end
    desc.strip
  end

  
end

