require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get faq" do
    get :faq
    assert_response :success
  end

  test "should get news" do
    get :news
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get coins" do
    get :coins
    assert_response :success
  end

  test "should get cards" do
    get :cards
    assert_response :success
  end

  test "should get checks" do
    get :checks
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
  end

  test "should get tos" do
    get :tos
    assert_response :success
  end

end
