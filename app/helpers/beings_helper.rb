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
    end.shuffle.first.strip
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

  def possessive_name_or_pronoun(being)
    rand > 0.333 ? possessive_pronoun(being) : possessive(being)
  end

  def describe(being, &block)
    being.description.sort{ |a,b| a.keys.first <=> b.keys.first }.each do |tuple|
      quality = tuple.values.first.first.to_s.humanize.downcase
      next if quality =~ /not notable/
      yield(quality,
            tuple.keys.first.to_s.humanize.downcase,
            tuple.values.first.last)
    end
  end

  def describe_table(being)
    capture_haml do
      haml_tag :table, { class:'table table-striped table-bordered table-condensed'} do
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


  def possessive(being)
    being.name.split.first.possessive
  end

  def pronoun(being)
    case being.gender.to_sym
    when :male then 'he'
    when :female then 'she'
    else 'its'
    end
  end

  def conjunction(continued)
    continued ? [' and ', ' but ', ' although ', ' even if ', ' even though ', '; '].shuffle.pop : ''
  end

  ##
  # Provides a description based on the genetics of the being.
  #
  def describe_paragraph(being)
    desc = ''
    continued = false
    describe(being) do |quality, key, amount|
      possessive = possessive_name_or_pronoun(being)
      possessive.capitalize! unless continued
      desc += [conjunction(continued),
               possessive,
               key,
               key.pluralize == key ? 'are' : 'is',
               strength(amount),
               quality].join(' ')
      continued = rand < 0.333 && !continued
      desc += "." unless continued
    end
    desc.strip
  end

end

