class SettlementsController < ApplicationController
  # GET /settlements
  # GET /settlements.json
  def index
    @settlements = Settlement.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @settlements }
      format.markdown # index.markdown.haml
    end
  end

  # GET /settlements/1
  # GET /settlements/1.json
  def show
    @settlement = Settlement.find(params[:id])
    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @settlement }
      format.markdown { render markdown:@settlement,  stream: true }
    end
  end

  # GET /settlements/new
  # GET /settlements/new.json
  def new
    @settlement = Settlement.new

    respond_to do |format|
      format.html # new.html.haml
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
    @settlement.populate params[:settlement][:population]
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
    @settlement.seed!
    flash[:notice] = "#{@settlement.name} seeded with families: #{@settlement.family_names.join(', ')}"
    render :show
  end


  # PUT /settlements/1
  # PUT /settlements/1.json
  def update
    @settlement = Settlement.find(params[:id])
    # did the population change? if so, wipe and recreate from scratch
    if @settlement.population != params[:settlement][:population]
      @settlement.residents.delete_all
      @settlement.populate params[:settlement][:population]
    end

    respond_to do |format|
      if @settlement.update_attributes(params[:settlement])
        format.html { redirect_to @settlement, notice: 'Settlement was successfully updated.' }
        format.json { respond_with_bip(@settlement) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@settlement) }
      end
    end
  end

  # DELETE /settlements/1
  # DELETE /settlements/1.json
  def destroy
    @settlement = Settlement.find(params[:id])
    @settlement.destroy

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { head :ok }
    end
  end

  def random_name
     render json: Settlement.random_name.as_json
  end


end
