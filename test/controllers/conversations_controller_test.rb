require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # Sign in Carrier
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
  
    carrier = carriers(:one)
  
    sign_in carrier

    # Set Bid
    @bid = bids(:one)
    @shipment_request = shipment_requests(:one)
  end

  test 'should get new from bid' do
    xhr :post, :new_from_bid, id: @bid.id, bid_id: @bid.id
    
    assert_not_nil assigns(:conversation)
    
    assert_response :success
  end

  test 'should get new from shipment request' do
    xhr :post, :new_from_shipment_request, id: @shipment_request.id, shipment_request_id: @bid.id
  
    assert_not_nil assigns(:conversation)
  
    assert_response :success
  end

  test 'should create conversation' do
    assert_difference('Conversation.count') do
      xhr :post, :create, conversation: {
        topic_id: @bid.id,
        topic_type: 'Bid',
        messages_attributes: [
          body: 'Hello world!',
        ]
      }
    end

    assert_response :success
  end

  test 'should edit conversation' do
    xhr :get, :edit, id: conversations(:one).id
    
    assert_response :success
  end
end
