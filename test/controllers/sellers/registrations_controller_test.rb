require 'test_helper'

class SellerRegistrationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @controller = Sellers::RegistrationsController.new
  
    @request.env['devise.mapping'] = Devise.mappings[:seller]
  end

  test 'Can create controller' do
    controller = Sellers::RegistrationsController.new
  
    assert_not_nil controller
  end

  test 'Should sign up a seller' do
    assert_nil Seller.find_by(email: correct_user_data[:email])
    
    post :create, seller: correct_user_data
    
    assert_not_nil Seller.find_by(email: correct_user_data[:email])
  end

  test 'Should not sign up a seller' do
    assert_nil Seller.find_by(email: incorrect_user_data[:email])
  
    post :create, seller: incorrect_user_data
    
    assert_nil Seller.find_by(email: incorrect_user_data[:email])
  end

  private

  def correct_user_data
    return {
      business_name: 'Seller A',
      email: 'seller_a@seller.com',
      address: 'Some Address 1234',
      phone_number: 123456,
      password: 'password',
      password_confirmation: 'password',
    }
  end
  
  def incorrect_user_data
    return {
      email: 'seller_b@seller.com',
    }
  end
  
end
