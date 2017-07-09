require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test 'Correct sign up' do
    user = User.new(
      name: 'Nombre',
      last_name: 'Apellido',
      email: 'a@a.com',
      password: 'algunode'
    )
    
    assert_equal true, user.save
  end

  test 'Too short password' do
    user = User.new(
      name: 'Nombre',
      last_name: 'Apellido',
      email: 'a@a.com',
      password: 'corto'
    )

    assert_equal false, user.save
    assert_equal 1, user.errors.count
    assert_equal true, user.errors[:password].any?
    assert_equal ['es demasiado corto (mínimo 8 caracteres)'], user.errors[:password]
    
  end
  
  test 'User without mandatory data' do
    user = User.new()
    
    assert_equal false, user.save
    assert_equal 4, user.errors.count
    assert_equal true, user.errors[:name].any?
    assert_equal true, user.errors[:last_name].any?
    assert_equal true, user.errors[:email].any?
    assert_equal true, user.errors[:password].any?
  end

  #####email uniqueness tests
  
  test 'Another user has the same email' do
    user = User.new(
      name: 'Nombre',
      last_name: 'Apellido',
      email: users(:cacho_castaña).email,
      password: 'muysecreto'
    )
    
    assert_equal false, user.save
    assert_equal 1, user.errors.count
    assert_equal true, user.errors[:email].any?
    assert_equal ['ya fué usado por un usuario'], user.errors[:email]
  end

  test 'Another carrier has the same email' do
    user = User.new(
      name: 'Nombre',
      last_name: 'Apellido',
      email: carriers(:one).email,
      password: 'muysecreto'
    )
  
    assert_equal false, user.save
    assert_equal 1, user.errors.count
    assert_equal true, user.errors[:email].any?
    assert_equal ['ya fué usado por un transportista'], user.errors[:email]
  end

  test 'Another seller has the same email' do
    user = User.new(
      name: 'Nombre',
      last_name: 'Apellido',
      email: sellers(:one).email,
      password: 'muysecreto'
    )
  
    assert_equal false, user.save
    assert_equal 1, user.errors.count
    assert_equal true, user.errors[:email].any?
    assert_equal ['ya fué usado por un vendedor'], user.errors[:email]
  end
end
