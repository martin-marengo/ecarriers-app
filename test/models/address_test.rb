require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  test 'Correct address' do
    address = Address.new(
        street_name: 'Juan de Garay',
        street_number: '1835',
        location_description: 'San Francisco, Córdoba, Argentina',
        city: correct_city,
        lat: 50,
        lng: 50
    )

    assert_equal true, address.save
  end

  test 'Correct and complete address' do
    address = Address.new(
        street_name: 'Juan de Garay',
        street_number: '1835',
        floor_number: '5',
        apartment: 'B',
        location_description: 'San Francisco, Córdoba, Argentina',
        city: correct_city,
        lat: 50,
        lng: 50
    )

    assert_equal true, address.save
  end

  test 'Empty address' do
    address = Address.new()
    
    assert_equal false, address.save
    
    assert_equal 3, address.errors.count
    assert_equal true, address.errors[:street_name].any?
    assert_equal true, address.errors[:street_number].any?
    assert_equal true, address.errors[:city].any?
  end
end
