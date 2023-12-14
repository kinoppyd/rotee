require "test_helper"

class ListTest < ActiveSupport::TestCase
  def setup
    @dashboard = dashboards(:one)
  end

  test "tick don't moves pointer when list is empty" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 1.second, dashboard: @dashboard)

    list.tick!
    assert_equal 0, list.pointer
  end

  test "tick moves pointer forward 1 when over trigger_at 1 day" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 1.second, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    list.tick!
    assert_equal 1, list.pointer
  end

  test "tick moves pointer forward 2 when over trigger_at 2 days" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 2.days, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)
    list.items.create!(name: 'item3', position: 2)

    list.tick!
    assert_equal 2, list.pointer
  end

  test "tick moves pointer forward 2, but rollback to 0 when over trigger_at 2 days and list size is 2" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 2.days, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    list.tick!
    assert_equal 0, list.pointer
  end

  test "don't tick twice" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 1.second, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    list.tick!
    list.tick!
    assert_equal 1, list.pointer
  end

  test "tick moves pointer forward 1 when over trigger_at 1 week" do
    list = List.create!(title: 'test', pointer: 0, cycle: 1, next_trigger_at: Time.current - 7.days, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    list.tick!
    assert_equal 1, list.pointer
  end

  test "tick moves pointer forward 2 when over trigger_at 2 weeks" do
    list = List.create!(title: 'test', pointer: 0, cycle: 1, next_trigger_at: Time.current - 14.days, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)
    list.items.create!(name: 'item3', position: 2)

    list.tick!
    assert_equal 2, list.pointer
  end

  test "tick moves pointer forward 2, but rollback to 0 when over trigger_at 2 weeks and list size is 2" do
    list = List.create!(title: 'test', pointer: 0, cycle: 0, next_trigger_at: Time.current - 14.days, dashboard: @dashboard)
    list.items.create!(name: 'item1', position: 0)
    list.items.create!(name: 'item2', position: 1)

    list.tick!
    assert_equal 0, list.pointer
  end

end
