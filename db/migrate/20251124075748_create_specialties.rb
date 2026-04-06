class CreateSpecialties < ActiveRecord::Migration[7.2]
  def change
    create_table :specialties do |t|
      t.string :name, null: false
      t.references :region, foreign_key: true
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.references :user, foreign_key: true 

      t.timestamps
    end
  end
end
