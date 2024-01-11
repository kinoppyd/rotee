require "test_helper"

class DayOfWeekIntegerTest < ActiveSupport::TestCase
  test 'sunday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:sun)

    assert obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'monday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:mon)

    assert_not obj.sunday?
    assert obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'tuesday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:tue)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'wednesday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:wed)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'thursday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:thu)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'friday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:fri)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'saturday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:sat)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert restore.saturday?
    assert_not obj.none?
  end

  test 'all days symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:sun, :mon, :tue, :wed, :thu, :fri, :sat)

    assert obj.sunday?
    assert obj.monday?
    assert obj.tuesday?
    assert obj.wednesday?
    assert obj.thursday?
    assert obj.friday?
    assert obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert restore.sunday?
    assert restore.monday?
    assert restore.tuesday?
    assert restore.wednesday?
    assert restore.thursday?
    assert restore.friday?
    assert restore.saturday?
    assert_not obj.none?
  end

  test 'week days symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:mon, :tue, :wed, :thu, :fri)

    assert_not obj.sunday?
    assert obj.monday?
    assert obj.tuesday?
    assert obj.wednesday?
    assert obj.thursday?
    assert obj.friday?
    assert_not obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert restore.monday?
    assert restore.tuesday?
    assert restore.wednesday?
    assert restore.thursday?
    assert restore.friday?
    assert_not restore.saturday?
    assert_not obj.none?
  end

  test 'monday, wednesday and saturday symbol creates expected object' do
    obj = Timer::DayOfWeekInteger.from_symbols(:mon, :wed, :sat)

    assert_not obj.sunday?
    assert obj.monday?
    assert_not obj.tuesday?
    assert obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert obj.saturday?
    assert_not obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert restore.monday?
    assert_not restore.tuesday?
    assert restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert restore.saturday?
    assert_not obj.none?
  end

  test 'ignores non days of week symbols' do
    obj = Timer::DayOfWeekInteger.from_symbols(:hoge, :foo)

    assert_not obj.sunday?
    assert_not obj.monday?
    assert_not obj.tuesday?
    assert_not obj.wednesday?
    assert_not obj.thursday?
    assert_not obj.friday?
    assert_not obj.saturday?
    assert obj.none?

    restore = Timer::DayOfWeekInteger.new(obj.to_i)

    assert_not restore.sunday?
    assert_not restore.monday?
    assert_not restore.tuesday?
    assert_not restore.wednesday?
    assert_not restore.thursday?
    assert_not restore.friday?
    assert_not restore.saturday?
    assert obj.none?
  end

  test 'raise error when not integer value are given' do
    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      Timer::DayOfWeekInteger.new(:mon)
    end
  end

  test 'raise error when minus value are given' do
    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      Timer::DayOfWeekInteger.new(-1)
    end
  end

  test 'raise error when overflow value are given' do
    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      Timer::DayOfWeekInteger.new(Timer::DayOfWeekInteger::ALL_DAYS + 1)
    end
  end

  test 'raise error when to integer with invalid status' do
    obj = Timer::DayOfWeekInteger.new(0)
    obj.send(:instance_variable_set, :@stat, -1)

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.to_i
    end
  end

  test 'raise error when ask day of week name with invalid status' do
    obj = Timer::DayOfWeekInteger.new(0)
    obj.send(:instance_variable_set, :@stat, -1)

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.sunday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.monday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.tuesday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.wednesday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.thursday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.friday?
    end

    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      obj.saturday?
    end
  end

  test 'to_syms returns available days' do
    obj = Timer::DayOfWeekInteger.from_symbols(:sun, :mon)
    assert_equal [:sun, :mon], obj.to_syms
  end
end
