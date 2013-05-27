class Corpus < Hash
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  belongs_to :language

  @@start_token = ' '
  @@end_token = ' '

  ##
  # Compiles the letter probability data structure.
  #
  def histogram(lookback)
    histo = Hash.new
    key = [@@start_token] * lookback
    get_text.each do |char|
      ((histo[key.clone] ||= { })[char] ||= 0)
      histo[key.clone][char] += 1
      key.push(char).shift
    end
    histo
  end

  ##
  # Reads the file from the web and converts it into an array
  # @see Corpus#compile_histogram
  # TODO: make this work even if pointed to a large file
  #
  def get_text
    Net::HTTP.get(URI('http://' + url.gsub(/http:\/\//,''))).downcase.split(//)#gsub(/[[:[punct]:]:]/, ' ').downcase.gsub(/\s+/, @@end_token).split(//)
  end

end

