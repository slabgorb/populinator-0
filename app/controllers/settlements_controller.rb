class SettlementsController < ApplicationController
  # GET /settlements
  # GET /settlements.json
  def index
    @settlements = Settlement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @settlements }
    end
  end

  # GET /settlements/1
  # GET /settlements/1.json
  def show
    @settlement = Settlement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @settlement }
    end
  end

  # GET /settlements/new
  # GET /settlements/new.json
  def new
    @settlement = Settlement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @settlement }
    end
  end

  # GET /settlements/1/edit
  def edit
    @settlement = Settlement.find(params[:id])
  end

  # POST /settlements
  # POST /settlements.json
  def create
    @settlement = Settlement.new(params[:settlement])
    @settlement.save
    params[:settlement][:population].to_i.times do
      @settlement.beings << Person.create
    end       
    params[:settlement][:population].to_i.times do
      @settlement.beings << Person.create
    end   
    @settlement.beings.each do |b| 
      b.settlement = @settlement 
      b.save
    end
    respond_to do |format|
      if @settlement.save
        format.html { redirect_to @settlement, notice: 'Settlement was successfully created.' }
        format.json { render json: @settlement, status: :created, location: @settlement }
      else
        format.html { render action: "new" }
        format.json { render json: @settlement.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def seed
    @settlement = Settlement.find(params[:id])
    @settlement.seed_original_families
    flash[:notice] = "#{@settlement.name} seeded"
    render :show
  end


  # PUT /settlements/1
  # PUT /settlements/1.json
  def update
    @settlement = Settlement.find(params[:id])
    # did the population change? if so, wipe and recreate from scratch
    if @settlement.population != params[:settlement][:population]
      @settlement.beings.delete_all
      @settlement.populate params[:settlement][:population]
    end

    respond_to do |format|
      if @settlement.update_attributes(params[:settlement])
        format.html { redirect_to @settlement, notice: 'Settlement was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @settlement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settlements/1
  # DELETE /settlements/1.json
  def destroy
    @settlement = Settlement.find(params[:id])
    @settlement.destroy

    respond_to do |format|
      format.html { redirect_to settlements_url }
      format.json { head :ok }
    end
  end
  
  def random_name 
     render :json => Settlement.random_name.as_json
  end

  
end
