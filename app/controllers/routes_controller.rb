require 'net/http'

class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy, :vehicles]

  def index
    @grouped_routes = Route.all.group_by(&:route_type)
  end

  def show
    direction_id = Trip::DIRECTIONS.find_index(route_params[:direction])
    @direction = route_params[:direction]

    trip_ids = Trip.where(
      route_external_id: @route.external_id,
      direction_id: direction_id
    ).pluck(:external_id)

    @shapes = Shape.joins(:trips)
                   .where(trips: { external_id: trip_ids })
                   .distinct

    @stops = Stop.joins(:stop_times)
                 .where(stop_times: { trip_external_id: trip_ids })
                 .distinct

    @vehicles = Mbta::Client.new.get_vehicles(route: @route.external_id, direction: direction_id)
  end

  def vehicles
    direction_id = Trip::DIRECTIONS.find_index(route_params[:direction])

    respond_to do |format|
      format.json do
        render json: Mbta::Client.new.get_vehicles(route: @route.external_id, direction: direction_id)
      end
    end
  end

  private

  def set_route
    @route = Route.find(params[:id])
  end

  def route_params
    params.permit(:id, :direction)
  end
end
