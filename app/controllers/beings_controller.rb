class BeingsController < ApplicationController
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
