class IndexController < ApplicationController
  def homepage
  end

  def icon_list
    render json: Dir.glob(File.join(Rails.root, 'app', 'assets', 'images', 'heraldry') + '/*.png').map{|m| File.basename(m).gsub(/\.png/,'')}
  end

end
