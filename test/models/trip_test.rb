require 'test_helper'

class TripTest < ActiveSupport::TestCase
  test 'Valid trip' do
    valid_trip = Trip.new(
      {
        status: Trip::STATUS_DRIVING,
        origin: cities(:san_francisco),
        destination: cities(:devoto),
        departure_date: Date.new,
        arrival_date: Date.new,
        carrier: carriers(:one),
        shipment_publications: [shipment_publications(:one)]
      }
    )
    
    assert_equal true, valid_trip.save
  end
  
  test 'Incorrect trip' do
    invalid_trip = Trip.new

    assert_equal false, invalid_trip.save
    assert_equal 7, invalid_trip.errors.count
    
    assert_equal true, invalid_trip.errors[:status].any?
    assert_equal true, invalid_trip.errors[:origin].any?
    assert_equal true, invalid_trip.errors[:destination].any?
    assert_equal true, invalid_trip.errors[:departure_date].any?
    assert_equal true, invalid_trip.errors[:arrival_date].any?
    assert_equal true, invalid_trip.errors[:carrier].any?
    assert_equal true, invalid_trip.errors[:shipment_publications].any?
    
  end
end
