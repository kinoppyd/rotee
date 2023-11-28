class CreateLists < ActiveRecord::Migration[7.1]
  def change
    create_table :lists do |t|
      t.string :title
      t.text :body
      t.integer :pointer
      t.integer :cycle
      t.datetime :next_trigger_at

      t.timestamps
    end
  end
end
