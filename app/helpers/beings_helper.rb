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
  def possessive(gender)
    case gender
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
      next if tuple.values.first.first =~ /not_notable/
      desc += [possessive(being.gender), 
               key.pluralize == key ? 'are' : 'is', 
               strength(tuple),
               tuple.keys.first.to_s.humanize.downcase].join(' ') + '.'
    end
  end

  
end

