require 'test_helper'

class LocationReportsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    
    user = users(:cacho_castaña)
    
    sign_in user
  end

  test 'should show location_report' do
    get :show, id: shipment_publications(:one)
    
    assert_not_nil true, assigns(:shipment_publication)
    assert_not_nil true, assigns(:location_report)
    
    assert_response :success
  end
end
