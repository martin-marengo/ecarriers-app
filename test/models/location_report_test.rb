require 'test_helper'

class LocationReportTest < ActiveSupport::TestCase
  test 'Correct Location Report' do
    location_report = LocationReport.new(
      trip: trips(:one),
      lat: 15.346540,
      lng: 46.456
    )
    
    assert_equal true, location_report.valid?
  end
  
  test 'Invalid Location Report' do
    location_report = LocationReport.new
    
    assert_equal false, location_report.valid?
    assert_equal 3, location_report.errors.count
    assert_equal true, location_report.errors[:trip].any?
    assert_equal true, location_report.errors[:lat].any?
    assert_equal true, location_report.errors[:lng].any?
  end
end
