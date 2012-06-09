module BeingsHelper
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

  def possessive(gender)
    case gender
      when 'male' then 'his'
      when 'female' then 'her'
      when 'neuter' then 'its'
    end
  end

end

