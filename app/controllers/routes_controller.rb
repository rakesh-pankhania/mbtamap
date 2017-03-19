require 'net/http'

class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  def index
    @grouped_routes = Route.all.group_by(&:route_type)
  end

  def show
    # TODO: predictionsbyroute returns alert headers, display them?
    # TODO: Set direction from URL param
    direction = '0'

    # Get route predictions
    prediction_json = JSON.parse(
      Net::HTTP.get(
        URI::HTTP.build(
          host: "realtime.mbta.com",
          path: "/developer/api/v2/predictionsbyroute",
          query: {
            api_key: ENV['MBTA_API_KEY'],
            route: @route.external_id,
            direction: direction,
            format: 'json'
          }.to_query
        )
      )
    )

    @stops = {}.with_indifferent_access
    @trip_ids = Set.new
    @stop_ids = Set.new
    trips = prediction_json['direction'].first['trip']
    trips.each do |trip|
      @trip_ids << trip['trip_id']
      trip['stop'].each do |stop|
        @stop_ids << stop['stop_id']
        sequence = stop['stop_sequence'].to_i
        @stops[sequence] ||= { name: stop['stop_name'] }
        @stops[sequence]['times'] ||= []
        time = nil
        if stop['sch_arr_dt'].present?
          time = Time.at(stop['sch_arr_dt'].to_i)
        elsif stop['pre_dt'].present?
          time = Time.at(stop['pre_dt'].to_i)
        end
        unless time.nil?
          time = time.strftime('%l:%M %P')
          time = "#{time} (#{trip['trip_headsign']})" unless trip['trip_headsign'].nil?
          @stops[sequence]['times'] << time
        end
      end
    end

    # Get realtime locations
    realtime_json = JSON.parse(
      Net::HTTP.get(
        URI::HTTP.build(
          host: "realtime.mbta.com",
          path: "/developer/api/v2/vehiclesbyroute",
          query: {
            api_key: ENV['MBTA_API_KEY'],
            route: @route.external_id,
            format: 'json'
          }.to_query
        )
      )
    )
    @vehicles = []
    realtime_json["direction"].first["trip"].each do |trip|
      @vehicles << trip['vehicle']
    end

    @stop_objects = Stop.where(external_id: @stop_ids.to_a)
    @shapes = Shape.where(id: Trip.where(external_id: @trip_ids.to_a).select(:shape_id))
  end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routes/1
  # PATCH/PUT /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url, notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.where(id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def route_params
      params.fetch(:route, {})
    end
end
