require "test_helper"

class TimerNextTickAtTest < ActiveSupport::TestCase
  def setup
    @timer = Timer.new
  end

  test 'change correct next_tick_at when trigger_day was changed (next day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
      assert_equal Time.local(2024, 1, 1), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (2 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun tue wed thu fri sat]
      assert_equal Time.local(2024, 1, 2), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (3 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun wed thu fri sat]
      assert_equal Time.local(2024, 1, 3), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (4 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun thu fri sat]
      assert_equal Time.local(2024, 1, 4), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (5 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun fri sat]
      assert_equal Time.local(2024, 1, 5), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (6 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun sat]
      assert_equal Time.local(2024, 1, 6), @timer.next_tick_at
    end
  end

  test 'change correct next_tick_at when trigger_day was changed (7 days after)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun]
      assert_equal Time.local(2024, 1, 7), @timer.next_tick_at
    end
  end

  test 'next_tick_at and last_ticked_at is same value when trigger_day was blank' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = []
      assert_nil @timer.next_tick_at
    end
  end

  test "don't change next_tick_at when trigger_day was not changed" do
    travel_to Date.new(2023, 12, 31) do
      dashboard = Dashboard.new(title: 'test')
      dashboard.save!
      list = dashboard.lists.build(title: 'test', pointer: 0)
      timer = list.build_timer(trigger_day: %i[sun mon tue wed thu fri sat])
      list.save!

      loaded_timer = Timer.find(timer.id)
      loaded_timer.trigger_day = %i[sun mon tue wed thu fri sat]
      assert_not loaded_timer.next_tick_at_changed?
    end
  end
end

class TimerTickReturnsTest < ActiveSupport::TestCase
  def setup
    travel_to Date.new(2023, 12, 31) do
      dashboard = Dashboard.new(title: 'test')
      dashboard.save!
      list = dashboard.lists.build(title: 'test', pointer: 0)
      @timer = list.build_timer(trigger_day: %i[sun mon tue wed thu fri sat])
      list.save!
    end
  end

  test 'tick! returns count of cross the threshold (0day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
    end

    travel_to Date.new(2023, 12, 31) do
      assert_equal 0, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (1day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
    end

    travel_to DateTime.new(2024, 1, 1, 13, 0, 0) do
      assert_equal 1, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (3day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
    end

    travel_to DateTime.new(2024, 1, 3, 13, 0, 0) do
      assert_equal 3, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (7day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
    end

    travel_to DateTime.new(2024, 1, 7, 13, 0, 0) do
      assert_equal 7, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (8day)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun mon tue wed thu fri sat]
    end

    travel_to DateTime.new(2024, 1, 8, 13, 0, 0) do
      assert_equal 8, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (limited days, 2days)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[sun tue thu fri sat]
    end

    travel_to DateTime.new(2024, 1, 4, 13, 0, 0) do
      assert_equal 2, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (week day, 5days)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[mon tue wed thu fri]
    end

    travel_to DateTime.new(2024, 1, 8, 13, 0, 0) do
      assert_equal 6, @timer.tick!
    end
  end

  test 'tick! returns count of cross the threshold (week day, 5days, 2 times)' do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = %i[mon tue wed thu fri]
    end

    travel_to DateTime.new(2024, 1, 8, 13, 0, 0) do
      assert_equal 6, @timer.tick!
    end

    travel_to DateTime.new(2024, 1, 15, 13, 0, 0) do
      assert_equal 5, @timer.tick!
    end
  end
end

class TimerTickChangesAtrributesTest < ActiveSupport::TestCase
  def setup
    travel_to Date.new(2023, 12, 31) do
      dashboard = Dashboard.new(title: 'test')
      dashboard.save!
      list = dashboard.lists.build(title: 'test', pointer: 0)
      @timer = list.build_timer(trigger_day: %i[sun mon tue wed thu fri sat])
      list.save!
    end
  end

  test 'tick! updates last_ticked_at' do
    travel_to Date.new(2024, 1, 1) do
      @timer.tick!
      assert_equal Time.local(2024, 1, 1), @timer.last_ticked_at
    end
  end

  test 'tick! updates last_ticked_at correctly if over 2 times corss the threshold' do
    travel_to Date.new(2024, 1, 3) do
      @timer.tick!
      assert_equal Time.local(2024, 1, 3), @timer.last_ticked_at
    end
  end

  test 'tick! updates next_tick_at' do
    travel_to Date.new(2024, 1, 1) do
      @timer.tick!
      assert_equal Time.local(2024, 1, 2), @timer.next_tick_at
    end
  end

  test 'tick! updates next_tick_at correctly if over 2 times corss the threshold' do
    travel_to Date.new(2024, 1, 3) do
      @timer.tick!
      assert_equal Time.local(2024, 1, 4), @timer.next_tick_at
    end
  end

  test "tick! don't update last_ticked_at if not cross the threshold" do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = [:sun]
    end

    travel_to Date.new(2024, 1, 1) do
      @timer.tick!
      assert_nil @timer.last_ticked_at
    end
  end

  test "tick! don't update next_tick_at if not cross the threshold" do
    travel_to Date.new(2023, 12, 31) do
      @timer.trigger_day = [:sun]
    end

    travel_to Date.new(2024, 1, 1) do
      @timer.tick!
      assert_equal Time.local(2024, 1, 7), @timer.next_tick_at
    end
  end
end

class TimerErrorTest < ActiveSupport::TestCase
  test 'raises error if trigger_day is not valid value (less than 0)' do
    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      Timer.new(trigger_day: -1)
    end
  end

  test 'raises error if trigger_day is not valid value (more than ALL_DAYS)' do
    assert_raises Timer::DayOfWeekInteger::InvalidStateError do
      Timer.new(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS + 1)
    end
  end
end