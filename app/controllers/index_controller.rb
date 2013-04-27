class IndexController < ApplicationController
  def homepage
    @settlements = Settlement.all
  end

end
