require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  
  test 'Correct region' do
    region = Region.new(
      name: 'San Luis',
      country: correct_country
    )
    
    assert_equal true, region.save
  end
  
  test 'Empty region' do
    region = Region.new
    
    assert_equal false, region.save
    
    assert_equal 2, region.errors.count
    assert_equal true, region.errors[:name].any?
    assert_equal true, region.errors[:country].any?
  end

  test 'Must not save two regions with same name' do
    same_region = regions(:cordoba)
  
    region = Region.new(
      name: same_region.name,
      country: same_region.country
    )
  
    # We can not save a region with the same name
    assert_equal false, region.save
  
    assert_equal 1, region.errors.count
    assert_equal true, region.errors[:name].any?
  end
  
end
