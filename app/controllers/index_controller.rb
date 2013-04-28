class IndexController < ApplicationController
  def homepage
    @settlements = Settlement.all
    @settlement = Settlement.new
  end

end
