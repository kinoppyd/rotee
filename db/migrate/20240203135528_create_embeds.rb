class CreateEmbeds < ActiveRecord::Migration[7.1]
  def change
    create_table :embeds, id: :string do |t|
      t.references :list, null: false, type: :string, foreign_key: true
      t.string :key

      t.timestamps
    end
    add_index :embeds, :key, unique: true
  end
end
