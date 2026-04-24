class AddStatusToSpecialties < ActiveRecord::Migration[7.2]
  def change
    add_column :specialties, :status, :integer, default: 0, null: false
    add_index :specialties, :status
  end
end
