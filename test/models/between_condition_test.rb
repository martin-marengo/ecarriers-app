require 'test_helper'

class BetweenConditionTest < ActiveSupport::TestCase

  test 'Valid between condition' do
    between_condition = BetweenCondition.new(
        from_date: DateTime.now,
        to_date: DateTime.tomorrow
    )

    assert_equal true, between_condition.save
    assert_equal BetweenCondition.name, between_condition.type
  end

  test 'Invalid equal dates' do
    date = DateTime.tomorrow
    between_condition = BetweenCondition.new(
        from_date: date,
        to_date: date
    )

    assert_equal false, between_condition.save
    assert_equal 1, between_condition.errors.count
    assert_equal true, between_condition.errors[:to_date].any?
    assert_equal [BetweenCondition::TO_DATE_ERROR_MESSAGE], between_condition.errors[:to_date]
  end

  test 'Invalid different dates' do
    between_condition = BetweenCondition.new(
        from_date: DateTime.tomorrow,
        to_date: DateTime.now
    )

    assert_equal false, between_condition.save
    assert_equal 1, between_condition.errors.count
    assert_equal true, between_condition.errors[:to_date].any?
    assert_equal [BetweenCondition::TO_DATE_ERROR_MESSAGE], between_condition.errors[:to_date]
  end

  test 'Empty between condition' do
    between_condition = BetweenCondition.new

    assert_equal false, between_condition.save
    assert_equal 2, between_condition.errors.count
    assert_equal true, between_condition.errors[:from_date].any?
    assert_equal true, between_condition.errors[:to_date].any?
  end

  test 'Between condition with date' do
    between_condition = BetweenCondition.new(
        from_date: DateTime.now,
        to_date: DateTime.tomorrow,
        date: DateTime.now
    )

    assert_equal false, between_condition.save
    assert_equal 1, between_condition.errors.count
    assert_equal true, between_condition.errors[:date].any?
  end
end
