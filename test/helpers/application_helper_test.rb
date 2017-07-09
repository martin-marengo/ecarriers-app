require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  
  test 'Distance in KM' do
    distance = distance_in_km [100, 100], [200, 200]

    assert_equal 12389.048053578606, distance
  end
end
