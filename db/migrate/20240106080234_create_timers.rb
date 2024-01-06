class CreateTimers < ActiveRecord::Migration[7.1]
  def change
    create_table :timers, id: :string do |t|
      t.datetime :last_ticked_at
      t.datetime :next_tick_at
      t.integer :trigger_day, null: false
      t.references :list, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
