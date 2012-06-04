module BeingsHelper
  def strength(tuple)
    case tuple.values.first.last
         when 0 then 'barely'
         when 1 then 'somewhat'
         when 2 then 'definitely'
         when 3 then 'very'
         when 4 then 'extremely'
         when 5 then 'ridiculously'
         when 6 then 'astonishingly'
    end
  end
end

