require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard = dashboards(:one)
    @list = lists(:one)
  end

  test "should get new" do
    get new_dashboard_list_url(@dashboard)
    assert_response :success
  end

  test "should create list" do
    assert_difference("List.count") do
      post dashboard_lists_url(@list.dashboard), params: { list: { body: @list.body, title: @list.title }, timer: { trigger_day: { "sun" => 0 } } }
    end

    assert_redirected_to list_url(List.order(created_at: :desc).first)
  end

  test "should show list" do
    get list_url(@list)
    assert_response :success
  end

  test "should get edit" do
    get edit_list_url(@list)
    assert_response :success
  end

  test "should update list" do
    patch list_url(@list), params: { list: { body: @list.body, title: @list.title }, timer: { trigger_day: { "sun" => 0 } } }
    assert_redirected_to list_url(@list)
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete list_url(@list)
    end

    assert_redirected_to dashboard_url(@list.dashboard)
  end
end
