require 'test_helper'

class ApiTokensControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:seller]
  end

  test 'should get index' do
    sign_in sellers(:one)
    
    get :index
    
    assert_response :success
  end

  test 'should redirect get index' do
    sign_in sellers(:two)
  
    get :index
  
    assert_response :redirect
  end

  test 'should get new' do
    sign_in sellers(:two)
    
    get :new
    
    assert_response :success
  end

  test 'should redirect get new' do
    sign_in sellers(:one)
  
    get :new
  
    assert_response :redirect
  end

  test 'should create api_token' do
    seller_before_create_token = sellers(:two)
    sign_in seller_before_create_token
    
    assert_nil seller_before_create_token.api_token
    
    xhr :post, :create

    seller_after_create_token = Seller.find(seller_before_create_token.id)
    assert_not_nil seller_after_create_token.api_token
  end

  test 'should destroy api_token' do
    seller_before_destroy_token = sellers(:one)
    sign_in seller_before_destroy_token
  
    assert_not_nil seller_before_destroy_token.api_token
  
    delete :destroy, id: 1
  
    seller_after_destroy_token = Seller.find(seller_before_destroy_token.id)
    assert_nil seller_after_destroy_token.api_token
  end
end
