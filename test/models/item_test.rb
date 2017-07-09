require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def shipment_publication(category)
    user = users(:cacho_castaña)
    user.save
    category.save
    pickup_address = addresses(:jonas_salk)
    pickup_address.save
    delivery_address = addresses(:buenos_aires)
    delivery_address.save
    pickup_condition = BeforeCondition.new(
        date: DateTime.now
    )
    pickup_condition.save
    delivery_condition = BeforeCondition.new(
        date: DateTime.tomorrow
    )
    delivery_condition.save

    shipment_publication = shipment_publications(:one)
    shipment_publication.client = user
    shipment_publication.category = category
    shipment_publication.pickup_address = pickup_address
    shipment_publication.delivery_address = delivery_address
    shipment_publication.pickup_service_condition = pickup_condition
    shipment_publication.delivery_service_condition = delivery_condition

    shipment_publication.save
    shipment_publication
  end
  
  test 'Valid complete item with all requested' do
    shipment_publication = shipment_publication(categories(:all_requested))
    item = items(:valid_complete)
    item.shipment_publication = shipment_publication

    assert_equal true, item.save
  end

  test 'Incomplete item with all requested' do
    shipment_publication = shipment_publication(categories(:all_requested))
    item = items(:valid_incomplete)
    item.shipment_publication = shipment_publication

    assert_equal false, item.save
    assert_equal 7, item.errors.count
    assert_equal true, item.errors[:length_m].any?
    assert_equal true, item.errors[:length_cm].any?
    assert_equal true, item.errors[:width_m].any?
    assert_equal true, item.errors[:width_cm].any?
    assert_equal true, item.errors[:height_m].any?
    assert_equal true, item.errors[:height_cm].any?
    assert_equal true, item.errors[:weight_kg].any?
  end

  test 'Complete item with nothing requested' do
    shipment_publication = shipment_publication(categories(:nothing_requested))
    item = items(:valid_complete)
    item.shipment_publication = shipment_publication

    assert_equal true, item.save
  end

  test 'Inomplete item with nothing requested' do
    shipment_publication = shipment_publication(categories(:nothing_requested))
    item = items(:valid_incomplete)
    item.shipment_publication = shipment_publication

    assert_equal true, item.save
  end

  test 'Incomplete measures with nothing requested' do
    shipment_publication = shipment_publication(categories(:nothing_requested))
    item = items(:valid_incomplete_measures)
    item.shipment_publication = shipment_publication

    assert_equal false, item.save
    assert_equal 4, item.errors.count
    assert_equal true, item.errors[:length_cm].any?
    assert_equal true, item.errors[:height_m].any?
    assert_equal true, item.errors[:height_cm].any?
    assert_equal true, item.errors[:weight_kg].any?
  end

  test 'Invalid item with all requested 1' do
    shipment_publication = shipment_publication(categories(:all_requested))
    item = items(:invalid_complete_1)
    item.shipment_publication = shipment_publication

    assert_equal false, item.save
    assert_equal 9, item.errors.count
    assert_equal true, item.errors[:length_m].any?
    assert_equal true, item.errors[:length_cm].any?
    assert_equal true, item.errors[:width_m].any?
    assert_equal true, item.errors[:width_cm].any?
    assert_equal true, item.errors[:height_m].any?
    assert_equal true, item.errors[:height_cm].any?
    assert_equal true, item.errors[:weight_kg].any?
    assert_equal true, item.errors[:quantity].any?
    assert_equal true, item.errors[:name].any?
  end

  test 'Invalid item with all requested 2' do
    shipment_publication = shipment_publication(categories(:all_requested))
    item = items(:invalid_complete_2)
    item.shipment_publication = shipment_publication

    assert_equal false, item.save
    assert_equal 8, item.errors.count
    assert_equal true, item.errors[:length_m].any?
    assert_equal true, item.errors[:length_cm].any?
    assert_equal true, item.errors[:width_m].any?
    assert_equal true, item.errors[:width_cm].any?
    assert_equal true, item.errors[:height_m].any?
    assert_equal true, item.errors[:height_cm].any?
    assert_equal true, item.errors[:weight_kg].any?
    assert_equal true, item.errors[:quantity].any?
  end

  test 'Invalid with nothing requested' do
    shipment_publication = shipment_publication(categories(:nothing_requested))
    item = items(:invalid_incomplete)
    item.shipment_publication = shipment_publication

    assert_equal false, item.save
    assert_equal 2, item.errors.count
    assert_equal true, item.errors[:quantity].any?
    assert_equal true, item.errors[:name].any?
  end
end
