require 'spec_helper'

describe Corpus do
  before :all do
    @corpus = Corpus.new(name: 'test', url: 'http://www.gutenberg.org/files/42698/42698-0.txt'); lng = Language.new(name: 'test')
  end

  context 'histogram' do
    it 'compiles' do
      @corpus.histogram(2).first.first.should eq(["^","^"])
    end
  end

end
