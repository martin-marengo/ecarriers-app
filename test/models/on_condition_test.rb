require 'test_helper'

class OnConditionTest < ActiveSupport::TestCase

  test 'Valid on condition' do
    on_condition = OnCondition.new(
        date: DateTime.now
    )

    assert_equal true, on_condition.save
    assert_equal 'OnCondition', on_condition.type
  end

  test 'On condition without date' do
    on_condition = OnCondition.new

    assert_equal false, on_condition.save
    assert_equal 1, on_condition.errors.count
    assert_equal true, on_condition.errors[:date].any?
  end

  test 'On condition with from and to dates' do
    on_condition = OnCondition.new(
        date: DateTime.now,
        from_date: DateTime.now,
        to_date: DateTime.now
    )

    assert_equal false, on_condition.save
    assert_equal 2, on_condition.errors.count
    assert_equal true, on_condition.errors[:from_date].any?
    assert_equal true, on_condition.errors[:to_date].any?
  end
end
