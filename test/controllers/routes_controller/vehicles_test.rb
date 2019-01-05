# frozen_string_literal: true

require 'test_helper'

class RoutesController::VehiclesTest < ActionDispatch::IntegrationTest
  test 'should get route vehicles as JSON' do
    @route = create(
      :route,
      agency_external_id: create(:agency).external_id,
      external_id: 'Green-D'
    )

    VCR.use_cassette('get_green_d_outbound_vehicles') do
      get route_direction_vehicles_url(@route, 'outbound'), as: :json
      assert_response :success

      body = JSON.parse(response.body)

      assert_equal 5, body.count
      assert_equal 'vehicle', body.first['type']
    end
  end
end
