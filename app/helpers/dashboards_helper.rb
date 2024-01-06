module DashboardsHelper
  # turbo frame tag id for new list in dashboard
  def new_list_id(dashboard)
    "new_list_in_#{dashboard.id}"
  end

  # Turbo frame tag for lists in dashboard
  def dashboard_lists_id(dashboard)
    "dashboard_lists_#{dashboard.id}"
  end
end
