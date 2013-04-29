class IndexController < ApplicationController
  def homepage
    @settlements = Settlement.all
    @settlement = Settlement.new
    @languages = Language.all
    @language = Language.new
    @corpus = Corpus.new
  end

end
