require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  test 'Invalid Budget' do
    budget = Budget.new
    
    assert_equal false, budget.valid?
    
    assert_equal 2, budget.errors.count
    assert_equal true, budget.errors[:shipment_request].any?
    assert_equal true, budget.errors[:price].any?
  end
end
