require 'test_helper'

class UserRegistrationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @controller = Users::RegistrationsController.new
  
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test 'Can create controller' do
    controller = Users::RegistrationsController.new
  
    assert_not_nil controller
  end

  test 'Should sign up an user' do
    assert_nil User.find_by(email: correct_user_data[:email])
  
    post :create, user: correct_user_data
  
    assert_not_nil User.find_by(email: correct_user_data[:email])
  end

  test 'Should not sign up an user' do
    assert_nil User.find_by(email: incorrect_user_data[:email])
  
    post :create, user: incorrect_user_data
  
    assert_nil User.find_by(email: incorrect_user_data[:email])
  end

  private

  def correct_user_data
    return {
      name: 'Name',
      last_name: 'Last name',
      email: 'user_a@user.com',
      password: 'password',
      password_confirmation: 'password',
    }
  end

  def incorrect_user_data
    return {
      email: 'user_b@user.com',
    }
  end
end
