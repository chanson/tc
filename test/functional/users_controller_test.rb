require 'minitest_helper'

describe UsersControllerTest do
  it 'must get index' do
    test "should get index" do
      get :index
      assert_response :success
    end
  end

  it 'must get show' do
    test "should get show" do
      get :show
      assert_response :success
    end
  end
end
