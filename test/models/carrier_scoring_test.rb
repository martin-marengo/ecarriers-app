require 'test_helper'

class CarrierScoringTest < ActiveSupport::TestCase
  test 'Incomplete CarrierScoring' do
    scoring = CarrierScoring.new
    
    assert_equal false, scoring.valid?
    assert_equal 3, scoring.errors.count
    assert_equal true, scoring.errors[:service_quality].any?
    assert_equal true, scoring.errors[:delivery_time].any?
    assert_equal true, scoring.errors[:recommended].any?
  end
  
  test 'Scoring out of limits' do
    scoring = valid_scoring
    
    # Set wrong data
    scoring.service_quality = CarrierScoring::MAX_SCORE + 1
    scoring.delivery_time = CarrierScoring::MIN_SCORE - 1
    
    assert_equal false, scoring.valid?
    assert_equal 2, scoring.errors.count
    assert_equal true, scoring.errors[:service_quality].any?
    assert_equal true, scoring.errors[:delivery_time].any?
  end
  
  private
  def valid_scoring
    CarrierScoring.new({
      service_quality: 4,
      delivery_time: 5,
      feedback: 'Some feedback',
      recommended:true
    })
  end
end
