require 'test_helper'

class ServiceAddendumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_addendum = service_addendums(:one)
  end

  test "should get index" do
    get service_addendums_url
    assert_response :success
  end

  test "should get new" do
    get new_service_addendum_url
    assert_response :success
  end

  test "should create service_addendum" do
    assert_difference('ServiceAddendum.count') do
      post service_addendums_url, params: { service_addendum: {  } }
    end

    assert_redirected_to service_addendum_url(ServiceAddendum.last)
  end

  test "should show service_addendum" do
    get service_addendum_url(@service_addendum)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_addendum_url(@service_addendum)
    assert_response :success
  end

  test "should update service_addendum" do
    patch service_addendum_url(@service_addendum), params: { service_addendum: {  } }
    assert_redirected_to service_addendum_url(@service_addendum)
  end

  test "should destroy service_addendum" do
    assert_difference('ServiceAddendum.count', -1) do
      delete service_addendum_url(@service_addendum)
    end

    assert_redirected_to service_addendums_url
  end
end
