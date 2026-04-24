class AddLimitToSpecialtiesName < ActiveRecord::Migration[7.2]
  def up
    # 既存データで100文字を超える name があれば安全に停止
    over_limit = execute("SELECT COUNT(*) FROM specialties WHERE LENGTH(name) > 100").first["count"].to_i
    if over_limit > 0
      raise ActiveRecord::IrreversibleMigration,
            "specialties.name が 100文字を超えるレコードが #{over_limit} 件あります。" \
            "先にデータを修正してから再実行してください。"
    end

    change_column :specialties, :name, :string, limit: 100, null: false
  end

  def down
    change_column :specialties, :name, :string, null: false
  end
end
