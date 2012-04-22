class SimulationController < ApplicationController
  def run
    param[:name] = 'New Settlement'
    param[:population] ||= 100
    @settlement = Settlement.new(params[:name])
    param[:population].times do 
      @settlement.beings << Being.new
    end
    @settlement.ruler = Ruler.new(:name => 'Foo', :title => 'Prince')
  end
end
