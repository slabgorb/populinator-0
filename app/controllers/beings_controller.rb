class BeingsController < ApplicationController
  
  before_filter lambda { @being = Being.find_by_slug_or_id(params[:id]) if params.has_key? :id  }

  # get the genotype for this being
  def genotype
    @genotype = @being.genotype
    render :layout => false
  end
  
  # get the history for this being
  def history
    render :layout => false
  end  
  # get the family for this being
  def family
    render :layout => false
  end  
  # get the description for this being
  def description
    render :layout => false
  end  

  # kill this being
  def kill
    @being.die!
    render :json => @being
  end
  
  # age this being one year
  def age
    params[:years] ||= '1'
    @being.age!(params[:years].to_i)
    render :json => @being
  end
  
  # bring this being back to life
  def resurrect
    @being.resurrect!
    render :json => @being
  end  


  # one being reproduces with another, creating a child
  def reproduce
    @parent_a = Being.find(params[:parent_a])
    @parent_b = Being.find(params[:parent_b])
    @child = @parent_a.reproduce_with @parent_b
    redirect_to :back
  end
  
  def randomize_genetics
    @being.chromosomes.each { |c| c.randomize! }
    @being.events << Event.new(name: 'Divine Intervention', description: "#{@being.name} was touched by the gods themselves and has dramatically changed.")
    render :json => @being
  end

  
  # GET /beings
  # GET /beings.json
  def index
    @beings = Being.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beings }
    end
  end

  # GET /beings/1
  # GET /beings/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @being }
    end
  end

  # GET /beings/new
  # GET /beings/new.json
  def new
    @being = Being.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @being }
    end
  end

  # GET /beings/1/edit
  def edit
  end

  # POST /beings
  # POST /beings.json
  def create
    @being = Being.new(params[:being])

    respond_to do |format|
      if @being.save
        format.html { redirect_to @being, notice: 'Being was successfully created.' }
        format.json { render json: @being, status: :created, location: @being }
      else
        format.html { render action: "new" }
        format.json { render json: @being.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beings/1
  # PUT /beings/1.json
  def update 
    if params.has_key? :person
      params[:being] = params[:person]
    end
    if params.has_key? :ruler
      params[:being] = params[:ruler]
    end
    
    if params[:being].has_key? :name
      params[:being][:surname] = params[:being][:name].split.last
      params[:being][:given_name] = params[:being][:name].split.first
    end

    respond_to do |format|
      if @being.update_attributes(params[:being])
        format.html { redirect_to @being, notice: 'Being was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @being.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beings/1
  # DELETE /beings/1.json
  def destroy
    @being.destroy

    respond_to do |format|
      format.html { redirect_to beings_url }
      format.json { head :ok }
    end
  end
end
