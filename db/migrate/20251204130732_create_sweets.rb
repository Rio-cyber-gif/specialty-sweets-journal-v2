class CreateSweets < ActiveRecord::Migration[7.2]
  def change
    create_table :sweets do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :region, null: false, foreign_key: { on_delete: :restrict }
      t.references :genre, null: false, foreign_key: { on_delete: :restrict }
      t.string :name, null: false, limit: 100
      t.text :description

      t.timestamps
    end
  end
end
