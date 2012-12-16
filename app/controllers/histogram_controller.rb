class HistogramController < ApplicationController
  def load_corpus
    render text: Net::HTTP.get(URI("http://#{params[:corpus].gsub(/http:\/\//, '')}"))
  end
  
  
end
