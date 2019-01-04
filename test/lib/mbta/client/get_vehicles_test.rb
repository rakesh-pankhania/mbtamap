require 'test_helper'

class Mbta::Client::GetVehiclesTest < ActiveSupport::TestCase
  test "should return vehicles array" do
    VCR.use_cassette("get_green_d_outbound_vehicles") do
      rv = Mbta::Client.new.get_vehicles(route: 'Green-D', direction: 0)

      assert_equal 5, rv.count
      assert_equal 'vehicle', rv.first['type']
    end
  end
end
