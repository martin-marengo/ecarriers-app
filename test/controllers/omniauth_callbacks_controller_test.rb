require 'test_helper'

class OmniauthCallbacksControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    OmniAuth.config.test_mode = true
    
    facebook_omniauth_hash = {
      'provider' => 'facebook',
      'uid' => '12345',
      'info' => {
        'name' => 'Cacho Castaña',
        'email' => 'cacho@castana.com',
        'verified' => true,
        'nickname' => 'Cachito'
      },
      'extra' => {
        'raw_info' => {
          'name' => 'Cacho Castaña',
        }
      }
    }
  
    OmniAuth.config.add_mock(:facebook, facebook_omniauth_hash)
    
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end
  
  test 'should log in with Facebook account' do
    identity = Identity.find_by(uid: '12345')
    user = User.find_by(email: 'cacho@castana.com')
    
    assert_nil identity
    assert_nil user
    
    get :facebook

    # User's asserts
    user = User.find_by(email: 'cacho@castana.com')

    assert_equal 'cacho@castana.com', user.email
    assert_equal 'Cacho', user.name
    assert_equal 'Castaña', user.last_name
    
    # Identity's asserts
    identity = Identity.find_by(uid: '12345')
    
    assert_equal '12345', identity.uid
    assert_equal 'facebook', identity.provider
    assert_equal user, identity.user
  end
end