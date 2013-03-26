require 'minitest_helper'
require 'rails/performance_test_help'

describe BrowsingTest do
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  describe 'test_homepage' do
    it 'must not fail?' do
      get '/'
    end
  end
end
