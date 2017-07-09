require 'test_helper'

class ApiCarriersControllerTest < ActionController::TestCase
  test 'Should login' do
    post :login, login_json
    
    assert_response :ok
  end

  test 'Mark Shipment Publication as being shipped' do
    shipment_publication_before_call = shipment_publications(:one)
    assert_not_equal ShipmentPublication::STATUS_BEING_SHIPPED, shipment_publication_before_call.status
  
    post :mark_as_being_shipped, mark_as_json(shipment_publication_before_call)
  
    assert_response :success
  
    shipment_publication_after_call = ShipmentPublication.find(shipment_publication_before_call.id)
    assert_equal ShipmentPublication::STATUS_BEING_SHIPPED, shipment_publication_after_call.status
  end

  test 'Mark Shipment Publication as delivered' do
    shipment_publication_before_call = shipment_publications(:one)
    assert_not_equal ShipmentPublication::STATUS_DELIVERED, shipment_publication_before_call.status
    
    post :mark_as_delivered, mark_as_json(shipment_publication_before_call)
    
    assert_response :success
  
    shipment_publication_after_call = ShipmentPublication.find(shipment_publication_before_call.id)
    assert_equal ShipmentPublication::STATUS_DELIVERED, shipment_publication_after_call.status
  end
  
  
  private
  
  def login_json
    <<-JSON
{
  "email": "carrier@transportista.com",
  "password": "some password"
}
JSON
  end
  
  def mark_as_json(shipment_publication)
    '
{
  "api_token": "api_token_one",
  "id": ' + shipment_publication.id.to_s + '
}
'
  end
  
end
