class ChangePrimaryKeyTypeToString < ActiveRecord::Migration[7.1]
  def change
    remove_column :lists, :dashboard_id
    remove_column :items, :list_id

    change_column :dashboards, :id, :string, null: false, primary_key: true
    change_column :lists, :id, :string, null: false, primary_key: true
    add_reference :lists, :dashboard, type: :string
    change_column :items, :id, :string, null: false, primary_key: true
    add_reference :items, :list, type: :string
  end
end
