require 'test_helper'

class DiscountsOnUsersControllerTest < ActionController::TestCase
  setup do
    @discounts_on_user = discounts_on_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts_on_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discounts_on_user" do
    assert_difference('DiscountsOnUser.count') do
      post :create, discounts_on_user: { discountPercentage: @discounts_on_user.discountPercentage, userRanges: @discounts_on_user.userRanges }
    end

    assert_redirected_to discounts_on_user_path(assigns(:discounts_on_user))
  end

  test "should show discounts_on_user" do
    get :show, id: @discounts_on_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discounts_on_user
    assert_response :success
  end

  test "should update discounts_on_user" do
    put :update, id: @discounts_on_user, discounts_on_user: { discountPercentage: @discounts_on_user.discountPercentage, userRanges: @discounts_on_user.userRanges }
    assert_redirected_to discounts_on_user_path(assigns(:discounts_on_user))
  end

  test "should destroy discounts_on_user" do
    assert_difference('DiscountsOnUser.count', -1) do
      delete :destroy, id: @discounts_on_user
    end

    assert_redirected_to discounts_on_users_path
  end
end
