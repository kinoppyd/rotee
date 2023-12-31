require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard = dashboards(:one)
  end

  test "should get new" do
    get new_dashboard_url
    assert_response :success
  end

  test "should create dashboard" do
    assert_difference("Dashboard.count") do
      post dashboards_url, params: { dashboard: { title: @dashboard.title } }
    end

    assert_redirected_to dashboard_url(Dashboard.order(created_at: :desc).first)
  end

  test "should show dashboard" do
    get dashboard_url(@dashboard)
    assert_response :success
  end

  test "should get edit" do
    get edit_dashboard_url(@dashboard)
    assert_response :success
  end

  test "should update dashboard" do
    patch dashboard_url(@dashboard), params: { dashboard: { title: @dashboard.title } }
    assert_redirected_to dashboard_url(@dashboard)
  end

  test "should destroy dashboard" do
    assert_difference("Dashboard.count", -1) do
      delete dashboard_url(@dashboard)
    end

    assert_redirected_to dashboards_url
  end
end
