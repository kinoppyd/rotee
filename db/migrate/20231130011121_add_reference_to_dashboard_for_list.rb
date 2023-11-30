class AddReferenceToDashboardForList < ActiveRecord::Migration[7.1]
  def change
    add_reference :lists, :dashboard, foreign_key: true, null: false
  end
end
