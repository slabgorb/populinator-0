class Corpus < Hash
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :histogram, type: String
  field :lookback, type: Integer
  belongs_to :language

  @@start_token = '^'
  @@end_token = '$'

  ##
  # Compiles the letter probability data structure.
  #
  def compile_histogram
    histo = Hash.new
    key = [@@start_token] * lookback
    get_text.each do |char|
      ((histo[key.clone] ||= { })[char] ||= 0)
      histo[key.clone][char] += 1
      key.push(char).shift
    end
    update_attribute(:histogram, histo.to_json)
  end

  ##
  # Reads the file from the web and converts it into an array
  # @see Corpus#compile_histogram
  # TODO: make this work even if pointed to a large file
  #
  def get_text
    Net::HTTP.get(URI('http://' + url.gsub(/http:\/\//,''))).gsub(/[ !@#\$%^&*\(\)-_=+{}\[\]|\\?\/.,0-9]/,' ').downcase.gsub(/\s/, @@end_token).split(//)
  end

  ##
  # Deserialize the json-format histogram
  #
  def data(force = false)
    @data = nil if force
    @data ||= JSON.parse(histogram)
  end

  def +(corpus)
    data.deep_merge(corpus.data)
  end

end

