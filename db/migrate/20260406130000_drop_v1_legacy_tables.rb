class DropV1LegacyTables < ActiveRecord::Migration[7.2]
  def up
    # V1で使用していた sweets テーブルの外部キーを先に削除
    remove_foreign_key :sweets, :users   if foreign_key_exists?(:sweets, :users)
    remove_foreign_key :sweets, :regions if foreign_key_exists?(:sweets, :regions)

    drop_table :sweets,     if_exists: true
    drop_table :categories, if_exists: true
    drop_table :genres,     if_exists: true
  end

  def down
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :genres do |t|
      t.string :name, limit: 50, null: false
      t.timestamps
      t.index :name, unique: true
    end

    create_table :sweets do |t|
      t.references :user,   null: false, foreign_key: { on_delete: :cascade }
      t.references :region, null: false, foreign_key: { on_delete: :restrict }
      t.string :name, limit: 100, null: false
      t.text :description
      t.timestamps
    end
  end
end
