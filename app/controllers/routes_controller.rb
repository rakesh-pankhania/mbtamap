require 'net/http'

class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  def index
    @grouped_routes = Route.all.group_by(&:route_type)
  end

  def show
    # TODO: predictionsbyroute returns alert headers, display them?
    direction_name = params[:direction].nil? ? 'outbound' : params[:direction].downcase
    direction = Trip::DIRECTIONS.find_index(direction_name)
    puts "Direction is #{direction_name}(#{direction}) based on #{params[:direction]}"

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
    trips = prediction_json['direction'][direction]['trip']
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
    realtime_json["direction"][direction]["trip"].each do |trip|
      @vehicles << trip['vehicle']
    end

    @stop_objects = Stop.where(external_id: @stop_ids.to_a)
    @shapes = Shape.where(id: Trip.where(external_id: @trip_ids.to_a).select(:shape_id))
  end

  private

  def set_route
    @route = Route.find(params[:id])
  end
end
