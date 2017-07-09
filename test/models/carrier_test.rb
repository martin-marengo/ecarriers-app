require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  
  test 'Correct sign up' do
    carrier = Carrier.new(
      business_name: 'Transportista A',
      email: 'b@b.com',
      phone_number: '456789',
      address: correct_address,
      company_description: 'Description',
      profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
      password: 'muysecreto'
    )
    
    assert_equal true, carrier.save
  end
  
  test 'Too short password' do
    carrier = Carrier.new(
      business_name: 'Transportista A',
      email: 'b@b.com',
      phone_number: '456789',
      address: correct_address,
      company_description: 'Description',
      profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
      password: 'corto'
    )
    
    assert_equal false, carrier.save
    assert_equal 1, carrier.errors.count
    assert_equal true, carrier.errors[:password].any?
    assert_equal ['es demasiado corto (mínimo 8 caracteres)'], carrier.errors[:password]
  
  end

  test 'Carrier without mandatory data' do
    carrier = Carrier.new()
  
    assert_equal false, carrier.save
    assert_equal 6, carrier.errors.count
    assert_equal true, carrier.errors[:business_name].any?
    assert_equal true, carrier.errors[:phone_number].any?
    assert_equal true, carrier.errors[:address].any?
    assert_equal true, carrier.errors[:company_description].any?
    assert_equal true, carrier.errors[:email].any?
    assert_equal true, carrier.errors[:password].any?
  end
  
  ##### email uniqueness tests
  
  test 'Another carrier has the same email' do
    carrier = Carrier.new(
      business_name: 'Transportista A',
      email: carriers(:one).email,
      phone_number: '456789',
      address: correct_address,
      company_description: 'Description',
      profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
      password: 'muysecreto'
    )
    
    assert_equal false, carrier.save
    assert_equal 1, carrier.errors.count
    assert_equal true, carrier.errors[:email].any?
    assert_equal ['ya fué usado por un transportista'], carrier.errors[:email]
  end

  test 'Another user has the same email' do
    carrier = Carrier.new(
      business_name: 'Transportista A',
      email: users(:cacho_castaña).email,
      phone_number: '456789',
      address: correct_address,
      company_description: 'Description',
      profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
      password: 'muysecreto'
    )
  
    assert_equal false, carrier.save
    assert_equal 1, carrier.errors.count
    assert_equal true, carrier.errors[:email].any?
    assert_equal ['ya fué usado por un usuario'], carrier.errors[:email]
  end

  test 'Another seller has the same email' do
    carrier = Carrier.new(
      business_name: 'Transportista A',
      email: sellers(:one).email,
      phone_number: '456789',
      address: correct_address,
      company_description: 'Description',
      profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
      password: 'muysecreto'
    )
  
    assert_equal false, carrier.save
    assert_equal 1, carrier.errors.count
    assert_equal true, carrier.errors[:email].any?
    assert_equal ['ya fué usado por un vendedor'], carrier.errors[:email]
  end
  
end
