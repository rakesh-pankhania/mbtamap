class ServiceAddendumsController < ApplicationController
  before_action :set_service_addendum, only: [:show, :edit, :update, :destroy]

  # GET /service_addendums
  # GET /service_addendums.json
  def index
    @service_addendums = ServiceAddendum.all
  end

  # GET /service_addendums/1
  # GET /service_addendums/1.json
  def show
  end

  # GET /service_addendums/new
  def new
    @service_addendum = ServiceAddendum.new
  end

  # GET /service_addendums/1/edit
  def edit
  end

  # POST /service_addendums
  # POST /service_addendums.json
  def create
    @service_addendum = ServiceAddendum.new(service_addendum_params)

    respond_to do |format|
      if @service_addendum.save
        format.html { redirect_to @service_addendum, notice: 'Service addendum was successfully created.' }
        format.json { render :show, status: :created, location: @service_addendum }
      else
        format.html { render :new }
        format.json { render json: @service_addendum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_addendums/1
  # PATCH/PUT /service_addendums/1.json
  def update
    respond_to do |format|
      if @service_addendum.update(service_addendum_params)
        format.html { redirect_to @service_addendum, notice: 'Service addendum was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_addendum }
      else
        format.html { render :edit }
        format.json { render json: @service_addendum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_addendums/1
  # DELETE /service_addendums/1.json
  def destroy
    @service_addendum.destroy
    respond_to do |format|
      format.html { redirect_to service_addendums_url, notice: 'Service addendum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_addendum
      @service_addendum = ServiceAddendum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_addendum_params
      params.fetch(:service_addendum, {})
    end
end
