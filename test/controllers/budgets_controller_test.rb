require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # Sign in Carrier
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in(users(:cacho_castaña))
    
    @shipment_request = shipment_requests(:one)
    @budget = budgets(:one)
  end

  test 'should get new' do
    xhr :get, :new, shipment_request_id: @shipment_request
  
    assert_response :success
  end
  
  test 'should create budget' do
    assert_difference('Budget.count') do
      xhr :post, :create, {
        shipment_request_id: shipment_requests(:two).id,
        budget: {
          price: 500,
        }
      }
    end

    assert_response :success
  end

  test 'should get edit' do
    xhr :get, :edit, {
      shipment_request_id: @shipment_request.id,
      id: @budget.id
    }
    
    assert_response :success
  end

  test 'should update budget' do
    budget_before_edit = @budget
  
    assert_equal 10000, budget_before_edit.price_cents
    
    xhr :patch, :update, {
      shipment_request_id: @shipment_request.id,
      id: @budget.id,
      budget: {
        price: 200
      }
    }

    assert_response :success
    
    budget_after_update = Budget.find(budget_before_edit.id)
    
    assert_equal 20000, budget_after_update.price_cents
  end

  test 'should destroy budget' do
    assert_difference('Budget.count', -1) do
      xhr :delete, :destroy, {
        shipment_request_id: @shipment_request.id,
        id: @budget.id
      }
    end

    assert_response :success
  end

  test 'should accept budget' do
    budget_before_accept = @budget
    assert_equal false, budget_before_accept.accepted
    
    xhr :post, :accept, {
      shipment_request_id: @shipment_request.id,
      id: @budget.id
    }
  
    assert_response :success
    
    budget_after_accept = Budget.find(budget_before_accept.id)
    assert_equal true, budget_after_accept.accepted
  end
end
