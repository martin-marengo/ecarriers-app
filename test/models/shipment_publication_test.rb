require 'test_helper'

class ShipmentPublicationTest < ActiveSupport::TestCase
  def complete_shipment_publication
    user = users(:cacho_castaña)
    pickup_address = addresses(:jonas_salk)
    delivery_address = addresses(:buenos_aires)
    pickup_condition = BeforeCondition.new(
        date: DateTime.now
    )
    delivery_condition = BeforeCondition.new(
        date: DateTime.tomorrow
    )
    
    shipment_publication = shipment_publications(:one)
    shipment_publication.client = user
    shipment_publication.category = categories(:all_requested)
    shipment_publication.pickup_address = pickup_address
    shipment_publication.delivery_address = delivery_address
    shipment_publication.pickup_service_condition = pickup_condition
    shipment_publication.delivery_service_condition = delivery_condition

    shipment_publication
  end

  test 'Complete shipment publication' do
    shipment_publication = complete_shipment_publication
    
    assert_equal true, shipment_publication.save
  end

  test 'Invalid shipment publication' do
    shipment_publication = shipment_publications(:incomplete)
    
    assert_equal false, shipment_publication.save
    assert_equal 8, shipment_publication.errors.count
    assert_equal true, shipment_publication.errors[:title].any?
    assert_equal true, shipment_publication.errors[:client].any?
    assert_equal true, shipment_publication.errors[:category].any?
    assert_equal true, shipment_publication.errors[:pickup_address].any?
    assert_equal true, shipment_publication.errors[:delivery_address].any?
    assert_equal true, shipment_publication.errors[:pickup_service_condition].any?
    assert_equal true, shipment_publication.errors[:delivery_service_condition].any?
    assert_equal true, shipment_publication.errors[:status].any?
  end
  
  test 'Accepted bid of carrier' do
    shipment_publications = ShipmentPublication.accepted_bid_of_carrier(carriers(:one))
    
    assert_equal 2, shipment_publications.count
  end
end
