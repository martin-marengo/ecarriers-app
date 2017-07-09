require 'test_helper'

class BidTest < ActiveSupport::TestCase
  test 'Invalid bid' do
    bid = Bid.new
    
    assert_equal false, bid.save
    assert_equal 4, bid.errors.count
    assert_equal true, bid.errors[:description].any?
    assert_equal true, bid.errors[:price].any?
    assert_equal true, bid.errors[:carrier].any?
    assert_equal true, bid.errors[:shipment_publication].any?
  end
  
  test 'Bid must have a price more than zero' do
    bid = bids(:bid_not_accepted)
    bid.price_cents = 0
    
    assert_equal false, bid.save
    assert_equal 1, bid.errors.count
    assert_equal true, bid.errors[:price].any?
  end
end
