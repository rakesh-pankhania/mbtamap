# frozen_string_literal: true

require 'mbta/client'

class RoutesController < ApplicationController
  before_action :set_route, only: %i[show vehicles]

  def index; end

  def show
    @direction = route_params[:direction]
    @shapes = @route.shapes.where(trips: { direction_id: @direction_id }).distinct
    @stops = @route.stops.where(trips: { direction_id: @direction_id }).distinct
    @vehicles = Mbta::Client.new.get_vehicles(route: @route.external_id, direction: @direction_id)
  end

  def vehicles
    respond_to do |format|
      format.json do
        render json: Mbta::Client.new.get_vehicles(route: @route.external_id, direction: @direction_id)
      end
    end
  end

  private

  def set_route
    @route = Route.find(params[:id])
    @direction_id = Trip::DIRECTIONS.find_index(route_params[:direction])
  end

  def route_params
    params.permit(:id, :direction)
  end
end
