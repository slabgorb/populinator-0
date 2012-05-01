module Chronology
  @@current_year = 0
  
  def current_year(add = 1)
    @@current_year += add
  end
end
