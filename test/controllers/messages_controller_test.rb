require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # Sign in Carrier
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
  
    carrier = carriers(:one)
  
    sign_in carrier

    # Set Conversation
    @conversation = conversations(:one)
  end

  test 'should create message' do
    assert_difference('Message.count') do
      xhr :post, :create, message: {
        body: 'Hello World',
        conversation_id: @conversation.id
      }
    end

    assert_response :success
  end
end
