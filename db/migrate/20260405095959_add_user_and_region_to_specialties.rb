class AddUserAndRegionToSpecialties < ActiveRecord::Migration[7.2]
  def change
    add_reference :specialties, :user, null: true, foreign_key: true unless column_exists?(:specialties, :user_id)
    add_reference :specialties, :region, null: false, foreign_key: true unless column_exists?(:specialties, :region_id)
  end
end
