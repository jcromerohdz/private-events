# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  setup do
    @user = users(:one)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should get show user' do
    get users_url(@user)
    assert_response :success
  end

  test 'should get signin user' do
    get signin_url
    assert_response :success
  end

  test 'should get signup user' do
    get signup_url
    assert_response :success
  end
end
