class Corpus
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :histogram, type: String
  field :lookback, type: Integer
  belongs_to :language

  @@start_token = '^'.bytes.first
  @@end_token = '$'.bytes.first
  ##
  # add the bytecode of a char to the histogram
  #
  def add_char(byte)
    @key ||= Array(1..lookback).map{ @@start_token }
    @histo[@key.pack('c*')] += 1
    @key.push(byte)
    @key.shift
  end

  ##
  # Reads the file from the web and converts it into an array
  # TODO: make this work even if pointed to a large file
  #
  def compile_histogram
    @histo = Hash.new(0)
    Net::HTTP.get(URI('http://' + url.gsub(/http:\/\//,''))).split(/[^[:alpha:]]|\s/).map(&:strip).reject(&:blank?).each do |word|
      add_char(@@start_token)
      word.downcase.bytes.each { |char| add_char char }
      add_char(@@end_token)
    end
    update_attribute(:histogram, @histo.to_json)
  end
end

module Markov


  class Base
    def initialize(lookback = 2, dictionary = 'dict.txt')
      @dictionary = File.new(dictionary, 'r').readlines
      @lookback = lookback
      @chain = Markov::Chain.new
    end

    def make_words
      @words = @dictionary.map{ |m| make_word m }
    end

    def make_word
      char = Markov::StartToken
      key = []
      word = ''
      @lookback.times { key.push Markov::StartToken.new }
      while !char.is_a?(EndToken)
        char = @chain.store(key)
        word += char if char.is_a?(String)
      end
      word
    end

  end

  class Chain
    @@start_word = '^'
    @@end_word   = '$'
    def initialize(lookback = 2)
      @lookback = lookback
      @store = { }
      @key = []
    end

    def add_char(char)
      @store[@key] ||= new CharList()
      @store[@key].add char
      @key.push(char)
      @key.shift()
    end

    ##
    # Add a string to the store
    #
    def add(string)
      @key = []
      string = string + endWord
      @lookback.times{ @key.shift @@start_word }
      string.bytes.to_a.each { |e| add_char e }
    end
  end

  class CharList
    attr_reader :total, :chars
    def initialize
      @chars = { }
      @total = 0
    end

    ##
    # add a single character
    #
    def add (char)
      @chars[char] ||= 0
      @chars[char] += 1
      @total += 1
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
    def choice(selection = rand(@total))
      position = 0
      @chars.each_with_index do |index, count|
        position += count
        if position >= selection
          return index
        end
      end
      false
    end
  end
end
