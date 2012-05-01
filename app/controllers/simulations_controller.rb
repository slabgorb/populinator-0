class SimulationsController < ApplicationController
  
  def setup
  end

  
  def run
    params[:name] ||= 'New Settlement'
    params[:population] ||= 100
    @settlement = Settlement.create(:name => params[:name])
    @settlement.established = 0
    params[:population].times do
      @settlement.beings << Person.create
    end
    @settlement.rulers << Ruler.create(:settlement => @settlement)
    @settlement.save
    @output = "Current population: #{@settlement.population}<br/>"
    100.times do 
      @year += 1
      @settlement.beings.each { |b| b.age += 1 }
      @settlement.beings.each do |person|
        if rand < 0.10 and person.age > 16 and not person.married?
          person.marry(person.find_spouse) 
          @output += "#{person} was married to #{person.spouse}"
          @output += "#{person} reproduced"
          # person.reproduce(@settlement.beings.select{|s| s.gender != person.gender }.shuffle.first) if rand < 0.01
        end
        if rand < 0.10 then
          event = Event.disasters.shuffle.first
          @output += "#{@settlement.name} #{event.description}"
          event.happened_to(@settlement, rand)
        end
        @output += "Current population: #{@settlement.population}<br/>"
      end
    end
  end
end
