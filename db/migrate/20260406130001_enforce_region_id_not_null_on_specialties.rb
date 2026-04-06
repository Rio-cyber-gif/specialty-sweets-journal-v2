class EnforceRegionIdNotNullOnSpecialties < ActiveRecord::Migration[7.2]
  def up
    # region_id が NULL のレコードが残っていれば安全に停止する
    null_count = Specialty.where(region_id: nil).count
    if null_count > 0
      raise ActiveRecord::IrreversibleMigration,
            "specialties に region_id が NULL のレコードが #{null_count} 件あります。" \
            "先にデータを修正してから再実行してください。"
    end

    change_column_null :specialties, :region_id, false
  end

  def down
    change_column_null :specialties, :region_id, true
  end
end
