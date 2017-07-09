require 'test_helper'

class AcceptBidsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  setup do
    @bid = bids(:bid_not_accepted)

    @request.env['devise.mapping'] = Devise.mappings[:user]

    user = users(:cacho_castaña)

    sign_in user
  end

  test 'should get new' do
    xhr :get, :new, bid_id: @bid.id
    
    assert_response :success
  end

  test 'should create accepted_bid' do
    bid_before_accepted = Bid.find(@bid.id)
    assert_nil bid_before_accepted.shipment_publication.accepted_bid
    
    post :create, bid: { id: @bid.id }
    
    bid_after_accepted = Bid.find(@bid.id)
    
    assert_not_nil bid_after_accepted.shipment_publication.accepted_bid
    assert_equal ShipmentPublication::STATUS_WAITING_PICKUP, bid_after_accepted.shipment_publication.status

    assert_redirected_to shipment_publication_url(bid_after_accepted.shipment_publication)
  end
end
