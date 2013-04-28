class IndexController < ApplicationController
  def homepage
    @settlements = Settlement.all
    @settlement = Settlement.new
    @languages = Language.all
    @language = Language.new
  end

end
