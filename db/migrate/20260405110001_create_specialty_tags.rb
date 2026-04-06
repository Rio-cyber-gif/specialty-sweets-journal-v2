class CreateSpecialtyTags < ActiveRecord::Migration[7.2]
  def change
    create_table :specialty_tags do |t|
      t.references :specialty, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :specialty_tags, %i[specialty_id tag_id], unique: true
  end
end
