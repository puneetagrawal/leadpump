require 'test_helper'

class DiscountsOnLocationsControllerTest < ActionController::TestCase
  setup do
    @discounts_on_location = discounts_on_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts_on_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discounts_on_location" do
    assert_difference('DiscountsOnLocation.count') do
      post :create, discounts_on_location: { discountPercentage: @discounts_on_location.discountPercentage, locationRanges: @discounts_on_location.locationRanges }
    end

    assert_redirected_to discounts_on_location_path(assigns(:discounts_on_location))
  end

  test "should show discounts_on_location" do
    get :show, id: @discounts_on_location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discounts_on_location
    assert_response :success
  end

  test "should update discounts_on_location" do
    put :update, id: @discounts_on_location, discounts_on_location: { discountPercentage: @discounts_on_location.discountPercentage, locationRanges: @discounts_on_location.locationRanges }
    assert_redirected_to discounts_on_location_path(assigns(:discounts_on_location))
  end

  test "should destroy discounts_on_location" do
    assert_difference('DiscountsOnLocation.count', -1) do
      delete :destroy, id: @discounts_on_location
    end

    assert_redirected_to discounts_on_locations_path
  end
end
