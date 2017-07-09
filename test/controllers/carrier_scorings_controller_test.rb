require 'test_helper'

class CarrierScoringsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    
    user = users(:pepe_alfonso)
    
    sign_in user
  end
  
  test 'should get new' do
    get :new, id: shipment_publications(:delivered).id
    
    assert_response :success
  end

  test 'should create carrier_scoring' do
    assert_difference('CarrierScoring.count') do
      post :create, carrier_scoring: { service_quality: 5, delivery_time: 5, feedback: 'Feedback', recommended: true,
                                       shipment_publication_id: shipment_publications(:delivered) }
    end
  end
end
