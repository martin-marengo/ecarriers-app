require 'test_helper'

class AfterConditionTest < ActiveSupport::TestCase

  test 'Valid after condition' do
    after_condition = AfterCondition.new(
        date: DateTime.now
    )

    assert_equal true, after_condition.save
    assert_equal 'AfterCondition', after_condition.type
  end

  test 'After condition without date' do
    after_condition = AfterCondition.new

    assert_equal false, after_condition.save
    assert_equal 1, after_condition.errors.count
    assert_equal true, after_condition.errors[:date].any?
  end

  test 'After condition with from and to dates' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_date: DateTime.now,
        to_date: DateTime.now
    )

    assert_equal false, after_condition.save
    assert_equal 2, after_condition.errors.count
    assert_equal true, after_condition.errors[:from_date].any?
    assert_equal true, after_condition.errors[:to_date].any?
  end
end
