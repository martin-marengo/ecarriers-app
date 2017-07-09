require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  
  test 'Correct country' do
    country = Country.new(
      name: 'Bolivia'
    )
    
    assert_equal true, country.save
  end
  
  test 'Empty country' do
    country = Country.new
    
    assert_equal false, country.save
    
    assert_equal 1, country.errors.count
    assert_equal true, country.errors[:name].any?
  end

  test 'Must not save two countries with same name' do
    same_country = countries(:argentina)
  
    country = Country.new(
      name: same_country.name
    )
  
    # We can not save a country with the same name
    assert_equal false, country.save
  
    assert_equal 1, country.errors.count
    assert_equal true, country.errors[:name].any?
  end
  
end
