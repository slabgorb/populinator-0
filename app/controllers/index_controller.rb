class IndexController < ApplicationController
  def homepage
    @settlements = Settlement.all
    @settlement = Settlement.new
    @languages = Language.all
    @language = Language.new
    @corpus = Corpus.new
  end

  def icon_list
    render json: Dir.glob(File.join(Rails.root, 'app', 'assets', 'images', 'heraldry') + '/*.png').map{|m| File.basename(m).gsub(/\.png/,'')}
  end

end
