require 'test_helper'

class CityTest < ActiveSupport::TestCase
  
  test 'Correct city' do
    city = City.new(
      name: 'Rafaela',
      region: correct_region,
      country: correct_country
    )
  
    assert_equal true, city.save
  end

  test 'Empty city' do
    city = City.new

    assert_equal false, city.save

    assert_equal 2, city.errors.count
    assert_equal true, city.errors[:name].any?
    assert_equal true, city.errors[:country].any?
  end

  test 'Must not save two cities with same name' do
    same_city = cities(:devoto)
    
    city = City.new(
      name: same_city.name,
      region: same_city.region,
      country: same_city.country
    )
    
    # We can not save a city with the same name
    assert_equal false, city.save
    
    assert_equal 1, city.errors.count
    assert_equal true, city.errors[:name].any?
  end
  
end
