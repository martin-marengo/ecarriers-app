require 'test_helper'

class BidsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # Sign in Carrier
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
  
    carrier = carriers(:one)
  
    sign_in carrier

    # Set Bid
    @bid = bids(:one)
  end

  test 'should get index' do
    get :index
    
    assert_response :success
    assert_not_nil assigns(:bids)
  end

  test 'should get pending' do
    get :pending
  
    assert_response :success
    assert_not_nil assigns(:bids)
  end

  test 'should get new' do
    xhr :get, :new, shipment_publication_id: shipment_publications(:one).id
    
    assert_response :success
  end

  test 'should create bid' do
    assert_difference('Bid.count') do
      xhr :post, :create, bid: {
        description: @bid.description, 
        price: @bid.price,
        shipment_publication_id: shipment_publications(:shipment_publication_without_accepted_bid).id,
        carrier_id: carriers(:one).id
      }
    end

    assert_response :success
  end

  test 'should get edit' do
    xhr :get, :edit, id: @bid
    assert_response :success
  end

  test 'should update bid' do
    xhr :patch, :update, id: @bid, bid: { description: @bid.description, price: @bid.price }

    assert_response :success
  end

  test 'should destroy bid' do
    assert_difference('Bid.count', -1) do
      xhr :delete, :destroy, id: @bid
    end

    assert_response :success
  end
end
