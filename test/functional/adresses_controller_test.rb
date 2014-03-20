require 'test_helper'

class AdressesControllerTest < ActionController::TestCase
  setup do
    @adress = adresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adress" do
    assert_difference('Adresse.count') do
      post :create, :adress => @adress.attributes
    end

    assert_redirected_to adress_path(assigns(:adress))
  end

  test "should show adress" do
    get :show, :id => @adress.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @adress.to_param
    assert_response :success
  end

  test "should update adress" do
    put :update, :id => @adress.to_param, :adress => @adress.attributes
    assert_redirected_to adress_path(assigns(:adress))
  end

  test "should destroy adress" do
    assert_difference('Adresse.count', -1) do
      delete :destroy, :id => @adress.to_param
    end

    assert_redirected_to adresses_path
  end
end
