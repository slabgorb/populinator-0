class Language
  include Mongoid::Document

  field :name, type: String
  field :lookback, type: Integer
  field :description, type: String
  field :glossary_json, type: String
  field :dictionary_file, type: String, default: File.join(Rails.root, 'words', 'dict.txt')
  has_many :corpora
  has_and_belongs_to_many :settlement

  ##
  # Combines the histograms of the related corpora
  #
  def histogram(force = false)
    @histogram = nil if force
    @histogram ||= corpora.inject({ }) do |m, c|
      m.deep_merge!(c.histogram(lookback))
    end
    @histogram
  end

  ##
  # Returns the deserialized glossary
  #
  def glossary(force = false)
    JSON.parse glossary_json
  end

  ##
  # make a word from the histogram
  #
  def word
    char = '^'
    key = ['^'] * lookback
    word = ''
    while char.first != '$'
      char = choice(key)
      word += char.first if char
      key.push(char.first).shift if char
    end
    word.gsub(/[^[:[alpha]:]]/, '')
  end

  ##
  # select a character based on a random value compared with the
  # character probability factorposition
  #
  # for example, assuming a structure of
  # a: 22
  # d: 5
  # e: 45
  # ..etc
  #
  # c = new Charlist
  # ... create structure as above ...
  # c.choice(25)
  # > 'd'
  #
  def choice(key)
    selection = rand(@histogram[key].map(&:length).sum)
    position = 0
    @histogram[key].each_with_index do |index, count|
      return index if (position += count) > selection
    end
    @histogram[key].first
  end

  def make_glossary
    gloss = { }
    File.open(dictionary_file, 'r') do |f|
      f.each do |word|
        gloss[word] = make_word
      end
    end
    update_attribute(glossary, gloss)
  end

  private
  def generate_slug
    name || id
  end

end
