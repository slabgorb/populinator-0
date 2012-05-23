class SimulationsController < ApplicationController
  layout 'application'
  
  def index
    @sizes = { 
      'Hamlet' => 25,
      'Village' => 100,
      'Town' => 2500,
      'City' => 10000
    }
  end 

   
  def setup
    @settlement = Settlement.new
    @ruler = Ruler.new
  end

  
  def run
    params[:name] ||= Settlement.random_name.first
    params[:population] ||= Settlement.random_name.last
    params[:years] ||= 10
    
    logger.debug '*' * 80
    logger.debug params
    @settlement = Settlement.create(:name => params[:name])
    @settlement.established = 0
    @settlement.populate params[:population]
    @settlement.rulers << Ruler.create(:settlement => @settlement, :age => Person.random_age)
    # @settlement.seed_original_families
    @year = 1  
    params[:years].to_i.times do
      @settlement.history << Event.new(description:"Year #{@year} population: #{@settlement.population}", name:"Population in year #{@year}", category:'milestone')
      
      if rand < 0.10 then
        event = Event.disasters.shuffle.first
        event.happened_to(@settlement, rand)
      end
      @settlement.beings.each { |b| b.age += 1 }
      @settlement.beings.each do |person|
      #   if rand < 0.10 and person.age > 16 and not person.married?
      #     person.marry(person.find_spouse) 
      #     @output += "#{person} was married to #{person.spouse}"
      #     @output += "#{person} reproduced"
      #     # 
      #   end
      #   # old age check
      #   person.die! if person.age > (@old_age * (rand + 0.20))
      #   @output += "Current population: #{@settlement.population}<br/>"
      #   person.save
        begin
          person.reproduce(person.spouse) if person.spouse.present? and rand < 0.10
        rescue ReproductionException
          logger.debug [person.gender, person.spouse.gender]
        end
      end
      @year += 1
    end
    render :json => @settlement
  end
end
