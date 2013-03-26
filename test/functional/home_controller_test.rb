require 'minitest_helper'

describe HomeControllerTest do
  describe 'test index' do
    it "should get index" do
      get :index
      assert_response :success
    end
  end
end
