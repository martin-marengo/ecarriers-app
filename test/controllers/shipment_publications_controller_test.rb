require 'test_helper'

class ShipmentPublicationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    
    user = users(:cacho_castaña)
    
    sign_in user
  end

  test 'should get index' do
    get :index
    
    assert_response :success
    
    assert_not_nil assigns(:shipment_publications)
    assert_not_nil assigns(:parent_categories)
  end

  test 'should get show' do
    get :show, id: shipment_publications(:one)
  
    assert_response :success

    assert_not_nil assigns(:shipment_publication)
  end
  
end
