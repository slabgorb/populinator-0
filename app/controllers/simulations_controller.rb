class SimulationsController < ApplicationController
  def run
    params[:name] ||= 'New Settlement'
    params[:population] ||= 100
    @settlement = Settlement.create(:name => params[:name])
    params[:population].times do
      @settlement.beings << Person.create
    end
    @settlement.rulers << Ruler.create(:settlement => @settlement)
    @settlement.save
    redirect_to settlement_path(@settlement.id)
  end
end
