require 'test_helper'

class RoutesController::ShowTest < ActionDispatch::IntegrationTest
  setup do
    @route = create(
      :route,
      agency_external_id: create(:agency).external_id,
      external_id: 'Green-D'
    )
  end

  test "should show route" do
    VCR.use_cassette("get_green_d_outbound_vehicles") do
      get route_direction_path(@route, 'outbound')
      assert_response :success
    end
  end
end
