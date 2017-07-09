require 'test_helper'

class ServiceConditionTest < ActiveSupport::TestCase

  def earlier_time
    # July 8, 2008, 09:10am, local time
    Time.local(2008, 7, 8, 9, 10)
  end

  def later_time
    # July 8, 2008, 10:45am, local time
    Time.local(2008, 7, 8, 10, 45)
  end

  test 'Empty type' do
    service_condition = ServiceCondition.new

    assert_equal false, service_condition.save
    assert_equal 1, service_condition.errors.count
    assert_equal true, service_condition.errors[:type].any?
  end

  ######### PICKUP TIMES

  test 'Valid different pickup times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time,
        to_time: later_time
    )

    assert_equal true, after_condition.save
  end

  test 'Valid equal pickup times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time,
        to_time: earlier_time
    )

    assert_equal true, after_condition.save
  end

  test 'Invalid pickup times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: later_time,
        to_time: earlier_time
    )

    assert_equal false, after_condition.save
    assert_equal 1, after_condition.errors.count
    assert_equal true, after_condition.errors[:to_time].any?
    assert_equal [ServiceCondition::TO_TIME_ERROR_MESSAGE], after_condition.errors[:to_time]
  end

  test 'Only pickup from time' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time
    )

    assert_equal true, after_condition.save
  end

  test 'Only pickup to time' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        to_time: earlier_time
    )

    assert_equal false, after_condition.save
    assert_equal 1, after_condition.errors.count
    assert_equal true, after_condition.errors[:from_time].any?
  end

  ######### DELIVERY TIMES

  test 'Valid different delivery times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time,
        to_time: later_time
    )

    assert_equal true, after_condition.save
  end

  test 'Valid equal delivery times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time,
        to_time: earlier_time
    )

    assert_equal true, after_condition.save
  end

  test 'Invalid delivery times' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: later_time,
        to_time: earlier_time
    )

    assert_equal false, after_condition.save
    assert_equal 1, after_condition.errors.count
    assert_equal true, after_condition.errors[:to_time].any?
    assert_equal [ServiceCondition::TO_TIME_ERROR_MESSAGE], after_condition.errors[:to_time]
  end

  test 'Only delivery from time' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        from_time: earlier_time
    )

    assert_equal true, after_condition.save
  end

  test 'Only delivery to time' do
    after_condition = AfterCondition.new(
        date: DateTime.now,
        to_time: earlier_time
    )

    assert_equal false, after_condition.save
    assert_equal 1, after_condition.errors.count
    assert_equal true, after_condition.errors[:from_time].any?
  end
end
