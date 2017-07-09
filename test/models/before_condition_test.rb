require 'test_helper'

class BeforeConditionTest < ActiveSupport::TestCase

  test 'Valid before condition' do
    before_condition = BeforeCondition.new(
        date: DateTime.now
    )

    assert_equal true, before_condition.save
    assert_equal 'BeforeCondition', before_condition.type
  end

  test 'Before condition without date' do
    before_condition = BeforeCondition.new

    assert_equal false, before_condition.save
    assert_equal 1, before_condition.errors.count
    assert_equal true, before_condition.errors[:date].any?
  end

  test 'Before condition with from and to dates' do
    before_codition = BeforeCondition.new(
        date: DateTime.now,
        from_date: DateTime.now,
        to_date: DateTime.now
    )

    assert_equal false, before_codition.save
    assert_equal 2, before_codition.errors.count
    assert_equal true, before_codition.errors[:from_date].any?
    assert_equal true, before_codition.errors[:to_date].any?
  end
end
