require 'test_helper'

class ShipmentRequestsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # Sign in Carrier
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in(users(:cacho_castaña))
    
    @shipment_request = shipment_requests(:one)
  end
  
  test 'should create shipment request' do
    assert_difference('ShipmentRequest.count') do
      xhr :post, :create, shipment_request: {
        items_description: 'Some items description', 
        user_trip_publication_id: user_trip_publications(:two)
      }
    end

    assert_response :success
  end

  test 'should update shipment request' do
    shipment_request_before_update = shipment_requests(:two)
  
    assert_equal 'Some description about items B', shipment_request_before_update.items_description
    
    xhr :patch, :update, {
      id: shipment_request_before_update.id,
      shipment_request: {items_description: 'Edited description'}
    }

    assert_response :success
    
    shipment_request_after_update = ShipmentRequest.find(shipment_request_before_update.id)
    
    assert_equal 'Edited description', shipment_request_after_update.items_description
  end

  test 'should destroy bid' do
    assert_difference('Budget.count', -1) do
      xhr :delete, :destroy, {
        id: @shipment_request.id,
      }
    end

    assert_response :success
  end
end
