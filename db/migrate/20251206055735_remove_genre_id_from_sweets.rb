class RemoveGenreIdFromSweets < ActiveRecord::Migration[7.2]
  def change
    remove_column :sweets, :genre_id, :integer
  end
end