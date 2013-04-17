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
  def strength(val)
    case val
    when 0 then ['a bit', 'somewhat', 'marginally', 'a little']
    when 1 then ['', '', 'certainly', 'rather']
    when 2 then ['markedly', 'noticeably', 'decidedly', 'especially']
    when 3 then ['very', 'really', 'greatly', 'truly']
    when 4 then ['extremely', 'terrifically', 'tremendously']
    when 5 then ['ridiculously', 'uniquely', 'intensely']
    else ['astonishingly', 'bizarrely', 'pathologically', 'impossibly', 'astoundingly']
    end.shuffle.first
  end

  ##
  # Gender specific possessive 
  #
  def possessive_pronoun(being)
    case being.gender
    when 'male' then 'his'
    when 'female' then 'her'
    else 'its'
    end
  end

  def describe(being, &block)
    being.description.each do |tuple|
      quality = tuple.values.first.first.to_s.humanize.downcase
      next if quality =~ /not notable/
      yield(quality, 
            tuple.keys.first.to_s.humanize.downcase, 
            tuple.values.first.last)
    end
  end

  def describe_table(being)
    capture_haml do 
      haml_tag :table do
        haml_tag :thead do
          haml_tag :tr do
            haml_tag(:th){ haml_concat "Trait" }
            haml_tag(:th){ haml_concat "Quality" }
            haml_tag(:th){ haml_concat "Amount" }
          end
        end
        haml_tag :tbody do 
          describe(being) do |quality, key, amount|
            haml_tag :tr do 
              haml_tag(:th){ haml_concat key }
              haml_tag(:th){ haml_concat quality }
              haml_tag(:th){ haml_concat amount }          
            end
          end
        end
      end
    end
  end

  
  ##
  # Provides a description based on the genetics of the being.
  #
  def describe_paragraph(being)
    desc = ''
    continued = false
    describe(being) do |quality, key, amount|
      pronoun = possessive_pronoun(being)
      pronoun.capitalize! unless continued
      conjunction = continued ? ['and', 'but', 'although'].shuffle.pop : ''
      desc += [conjunction,
               rand > 0.333 ? pronoun : possessive(being),
               key,
               key.pluralize == key ? 'are' : 'is', 
               strength(amount),
               quality].join(' ') 
      continued = rand < 0.333 && !continued
      desc += "." unless continued
      desc += "\n"
    end
    desc.strip
  end
  
end

