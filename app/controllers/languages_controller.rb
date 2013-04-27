require 'net/http'
class LanguageController < ApplicationController
  
  def new
  end

  def create 
    language = Language.new(params[:language])
  end
  
end
