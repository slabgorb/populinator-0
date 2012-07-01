require 'net/http'
class LanguageController < ApplicationController
  def load_corpus
    render text: Net::HTTP.get(URI("http://#{params[:corpus]}"))
  end
  
  def new
  end

end
