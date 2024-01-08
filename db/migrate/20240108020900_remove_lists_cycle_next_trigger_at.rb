class RemoveListsCycleNextTriggerAt < ActiveRecord::Migration[7.1]
  def change
    remove_column :lists, :cycle, type: :integer
    remove_column :lists, :next_trigger_at, type: :datetime
  end
end
