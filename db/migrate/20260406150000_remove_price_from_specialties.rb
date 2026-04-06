class RemovePriceFromSpecialties < ActiveRecord::Migration[7.2]
  def change
    remove_column :specialties, :price, :decimal, precision: 10, scale: 2
  end
end
