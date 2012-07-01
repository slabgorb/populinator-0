require 'net/http'
class LanguageController < ApplicationController
  def load_corpus
    render text: Net::HTTP.get(URI("http://#{params[:corpus].gsub(/http:\/\//, '')}"))
  end
  
  def new
  end

  def create 
    language = Language.new(params[:language])
  end
  
end
