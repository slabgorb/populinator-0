class BeingsController < ApplicationController

  # get the genotype for this being
  def genotype
    @being = Being.find(params[:id])
    @genotype = @being.genotype
    render :layout => false
  end

  # kill this being
  def kill
    @being = Being.find(params[:id])
    @being.die!
    redirect_to :back
  end
  
  # age this being one year
  def age
    @being = Being.find(params[:id])
    @being.age!
    redirect_to :back
  end
  
  # bring this being back to life
  def resurrect
    @being = Being.find(params[:id])
    @being.resurrect!
    redirect_to :back
  end  


  # one being reproduces with another, creating a child
  def reproduce
    @parent_a = Being.find(params[:parent_a])
    @parent_b = Being.find(params[:parent_b])
    @child = @parent_a.reproduce_with @parent_b
    redirect_to :back
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
    @being = Being.find(params[:id])
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
    @being = Being.find(params[:id])
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
    @being = Being.find(params[:id])
    if params.has_key? :person
      params[:being] = params[:person]
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
    @being = Being.find(params[:id])
    @being.destroy

    respond_to do |format|
      format.html { redirect_to beings_url }
      format.json { head :ok }
    end
  end
end
