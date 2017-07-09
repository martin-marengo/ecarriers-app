require 'test_helper'

class CarriersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
    
    carrier = carriers(:one)
    
    sign_in carrier
  end
  
  test 'Can create controller' do
    controller = CarriersController.new
    
    assert_not_nil controller
  end

  test 'should get index' do
    get :index
  
    assert_response :success
  end

  test 'should get show' do
    get :show, id: shipment_publications(:one)
    
    assert_response :success
  end

  test 'should get pending shipments' do
    get :pending_shipments, id: shipment_publications(:one)
    
    assert_not_nil assigns :pending_shipments
  end

  test 'should get delivered shipments' do
    get :delivered_shipments, id: shipment_publications(:one)
  
    assert_not_nil assigns :pending_shipments
  end

  test 'should get scorings' do
    get :scorings
  
    assert_not_nil assigns :carrier_scorings
  end
end
