require 'test_helper'

class ShipmentRequestTest < ActiveSupport::TestCase
  test 'Invalid Shipment Request' do
    shipment_request = ShipmentRequest.new
    
    assert_equal false, shipment_request.valid?
    
    assert_equal 3, shipment_request.errors.count
    assert_equal true, shipment_request.errors[:user].any?
    assert_equal true, shipment_request.errors[:user_trip_publication].any?
    assert_equal true, shipment_request.errors[:items_description].any?
  end
end
