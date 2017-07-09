require 'test_helper'

class CarrierRegistrationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @controller = Carriers::RegistrationsController.new

    @request.env['devise.mapping'] = Devise.mappings[:carrier]
  end
  
  test 'Can create controller' do
    controller = Carriers::RegistrationsController.new
    
    assert_not_nil controller
  end
  
  test 'Should sign up a carrier' do
    assert_nil Carrier.find_by(email: correct_user_data[:email])
    
    post :create, carrier: correct_user_data

    assert_not_nil Carrier.find_by(email: correct_user_data[:email])
  end

  test 'Should not sign up a carrier' do
    assert_nil Carrier.find_by(email: incorrect_carrier_data[:email])
  
    post :create, carrier: incorrect_carrier_data
  
    assert_nil Carrier.find_by(email: incorrect_carrier_data[:email])
  end
  
  private
  
  def correct_user_data
    return {
      business_name: 'Carrier A',
      email: 'carrier_a@carrier.com',
      phone_number: 123456,
      company_description: 'Description',
      password: 'password',
      password_confirmation: 'password',
      address_attributes: {
        street_name: 'Street',
        street_number: 1234,
        floor_number: 1,
        apartment: 1,
        location_description: 'San Francisco, Córdoba, Argentina',
        lat: 50,
        lng: 50,
        city_name: 'San Francisco',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      }
    }
  end

  def incorrect_carrier_data
    return {
      email: 'carrier_b@carrier.com',
      address_attributes: {
        street_name: 'Street',
        street_number: 1234,
        floor_number: 1,
        apartment: 1,
        location_description: 'San Francisco, Córdoba, Argentina',
        lat: 50,
        lng: 50,
        city_name: 'San Francisco',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      }
    }
  end
  
end
