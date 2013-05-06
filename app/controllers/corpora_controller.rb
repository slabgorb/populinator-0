class CorporaController < ApplicationController
  # GET /corpora
  # GET /corpora.json
  def index
    @corpora = Corpus.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @corpora }
    end
  end

  # GET /corpora/1
  # GET /corpora/1.json
  def show
    @corpus = Corpus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @corpus }
    end
  end

  # GET /corpora/new
  # GET /corpora/new.json
  def new
    @corpus = Corpus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @corpus }
    end
  end

  # GET /corpora/1/edit
  def edit
    @corpus = Corpus.find(params[:id])
  end

  # POST /corpora
  # POST /corpora.json
  def create

    @corpus = Corpus.new(params[:corpus])

    saved = @corpus.save
    @corpus.compile_histogram if saved

    respond_to do |format|
      if saved
        format.html { redirect_to @corpus, notice: 'Corpus was successfully created.' }
        format.json { render json: @corpus, status: :created, location: @corpus }
      else
        format.html { render action: "new" }
        format.json { render json: @corpus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /corpora/1
  # PUT /corpora/1.json
  def update
    @corpus = Corpus.find(params[:id])
    saved = @corpus.update_attributes(params[:corpus])

    @corpus.compile_histogram if saved

    respond_to do |format|
      if saved
        format.html { redirect_to @corpus, notice: 'Corpus was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @corpus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corpora/1
  # DELETE /corpora/1.json
  def destroy
    @corpus = Corpus.find(params[:id])
    @corpus.destroy

    respond_to do |format|
      format.html { redirect_to corpora_url }
      format.json { head :ok }
    end
  end
end
