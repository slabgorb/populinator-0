class Corpus
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :histogram, type: String
  field :lookback, type: Integer
  belongs_to :language

  @@start_token = :start
  @@end_token = :end

  ##
  # Reads the file from the web and converts it into an array
  # TODO: make this work even if pointed to a large file
  #
  def compile_histogram
    histo = Hash.new
    key = [@@start_token] * lookback
    get_text.split(//).each do |char|
      key.push(char).shift
      histo[key.clone] ||= { }
      histo[key.clone][char] ||= 0
      histo[key.clone][char] += 1
    end
    p histo
    update_attribute(:histogram, histo.to_json)
  end


  def get_text
    Net::HTTP.get(URI('http://' + url.gsub(/http:\/\//,''))).gsub(/[\b\s!@#\$%^&*\(\)-_=+{}\[\]|\\?\/.,0-9]/,' ').downcase
  end

  def data
    JSON.parse(histogram)
  end

  def +(histo)
    h = data
    histo.each_pair do |k,v|
      h[k.split(//)] += v
    end
    h
  end

end

