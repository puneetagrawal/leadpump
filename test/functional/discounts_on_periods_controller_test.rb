require 'test_helper'

class DiscountsOnPeriodsControllerTest < ActionController::TestCase
  setup do
    @discounts_on_period = discounts_on_periods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts_on_periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discounts_on_period" do
    assert_difference('DiscountsOnPeriod.count') do
      post :create, discounts_on_period: { discountPercentage: @discounts_on_period.discountPercentage, periodType: @discounts_on_period.periodType }
    end

    assert_redirected_to discounts_on_period_path(assigns(:discounts_on_period))
  end

  test "should show discounts_on_period" do
    get :show, id: @discounts_on_period
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discounts_on_period
    assert_response :success
  end

  test "should update discounts_on_period" do
    put :update, id: @discounts_on_period, discounts_on_period: { discountPercentage: @discounts_on_period.discountPercentage, periodType: @discounts_on_period.periodType }
    assert_redirected_to discounts_on_period_path(assigns(:discounts_on_period))
  end

  test "should destroy discounts_on_period" do
    assert_difference('DiscountsOnPeriod.count', -1) do
      delete :destroy, id: @discounts_on_period
    end

    assert_redirected_to discounts_on_periods_path
  end
end
