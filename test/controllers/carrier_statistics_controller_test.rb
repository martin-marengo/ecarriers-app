require 'test_helper'

class CarrierStatisticsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
    
    carrier = carriers(:one)
    
    sign_in carrier
  end

  test 'should get most requested destinations' do
    get :most_requested_destinations
  
    assert_response :success
  end

  test 'should get revenues' do
    get :revenues
  
    assert_response :success
  end
end
