require 'test_helper'

class SellerTest < ActiveSupport::TestCase
  
  test 'Correct sign up' do
    seller = Seller.new(
      business_name: 'Vendedor A',
      email: 'b@b.com',
      phone_number: '456789',
      address: 'Alguno',
      password: 'muysecreto'
    )
    
    assert_equal true, seller.save
  end
  
  test 'Too short password' do
    seller = Seller.new(
      business_name: 'Vendedor A',
      email: 'b@b.com',
      phone_number: '456789',
      address: 'Alguno',
      password: 'corto'
    )
    
    assert_equal false, seller.save
    assert_equal 1, seller.errors.count
    assert_equal true, seller.errors[:password].any?
    assert_equal ['es demasiado corto (mínimo 8 caracteres)'], seller.errors[:password]
  
  end

  test 'Seller without mandatory data' do
    seller = Seller.new()
  
    assert_equal false, seller.save
    assert_equal 5, seller.errors.count
    assert_equal true, seller.errors[:business_name].any?
    assert_equal true, seller.errors[:phone_number].any?
    assert_equal true, seller.errors[:address].any?
    assert_equal true, seller.errors[:email].any?
    assert_equal true, seller.errors[:password].any?
  end
  
  ##### email uniqueness tests
  
  test 'Another seller has the same email' do
    seller = Seller.new(
      business_name: 'Vendedor A',
      email: sellers(:one).email,
      phone_number: '456789',
      address: 'Alguno',
      password: 'muysecreto'
    )
    
    assert_equal false, seller.save
    assert_equal 1, seller.errors.count
    assert_equal true, seller.errors[:email].any?
    assert_equal ['ya fué usado por un vendedor'], seller.errors[:email]
  end

  test 'Another user has the same email' do
    seller = Seller.new(
      business_name: 'Vendedor A',
      email: users(:cacho_castaña).email,
      phone_number: '456789',
      address: 'Alguno',
      password: 'muysecreto'
    )
  
    assert_equal false, seller.save
    assert_equal 1, seller.errors.count
    assert_equal true, seller.errors[:email].any?
    assert_equal ['ya fué usado por un usuario'], seller.errors[:email]
  end

  test 'Another carrier has the same email' do
    seller = Seller.new(
      business_name: 'Vendedor A',
      email: carriers(:one).email,
      phone_number: '456789',
      address: 'Alguno',
      password: 'muysecreto'
    )
  
    assert_equal false, seller.save
    assert_equal 1, seller.errors.count
    assert_equal true, seller.errors[:email].any?
    assert_equal ['ya fué usado por un transportista'], seller.errors[:email]
  end
end
