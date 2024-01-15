require "test_helper"

class ListTest < ActiveSupport::TestCase
  def setup
    @dashboard = dashboards(:one)
  end

  test "tick don't moves pointer when list is empty" do
    travel_to Date.new(2023, 12, 31) do
      list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS)

      list.tick!
      assert_equal 0, list.pointer
    end
  end

  test "tick moves pointer forward 1 when over trigger_at 1 day" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS).save!
    end

    travel_to Date.new(2024, 1, 1) do
      list.tick!
      assert_equal 1, list.pointer
    end
  end

  test "tick moves pointer forward 1 then pointer 1 back to 0 when over trigger_at 1 day" do
    list = List.create!(title: 'test', pointer: 1, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS).save!
    end

    travel_to Date.new(2024, 1, 1) do
      list.tick!
      assert_equal 0, list.pointer
    end
  end

  test "tick moves pointer forward 2 when over trigger_at 2 days" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)
    list.items.create!(name: 'item3', position: 2)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS).save!
    end

    travel_to Date.new(2024, 1, 2) do
      list.tick!
      assert_equal 2, list.pointer
    end
  end

  test "tick moves pointer forward 2, but rollback to 0 when over trigger_at 2 days and list size is 2" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS).save!
    end

    travel_to Date.new(2023, 1, 2) do
      list.tick!
      assert_equal 0, list.pointer
    end
  end

  test "don't tick twice" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::ALL_DAYS).save!
    end

    travel_to Date.new(2024, 1, 1) do
      list.tick!
      list.tick!
      assert_equal 1, list.pointer
    end
  end

  test "tick moves pointer forward 1 when over trigger_at 1 week" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::SUN).save!
    end

    travel_to Date.new(2024, 1, 7) do
      list.tick!
      assert_equal 1, list.pointer
    end
  end

  test "tick moves pointer forward 2 when over trigger_at 2 weeks" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)
    list.items.create!(name: 'item3', position: 2)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::SUN).save!
    end

    travel_to Date.new(2024, 1, 14) do
      list.tick!
      assert_equal 2, list.pointer
    end
  end

  test "tick moves pointer forward 2, but rollback to 0 when over trigger_at 2 weeks and list size is 2" do
    list = List.create!(title: 'test', pointer: 0, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    travel_to Date.new(2023, 12, 31) do
      list.build_timer(trigger_day: Timer::DayOfWeekInteger::SUN).save!
    end

    travel_to Date.new(2024, 1, 14) do
      list.tick!
      assert_equal 0, list.pointer
    end
  end
end
