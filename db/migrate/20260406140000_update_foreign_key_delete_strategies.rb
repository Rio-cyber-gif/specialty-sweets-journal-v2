class UpdateForeignKeyDeleteStrategies < ActiveRecord::Migration[7.2]
  def up
    # ── comments ──────────────────────────────────────────────
    remove_foreign_key :comments, :users
    add_foreign_key    :comments, :users,      on_delete: :cascade

    remove_foreign_key :comments, :specialties
    add_foreign_key    :comments, :specialties, on_delete: :cascade

    # ── favorites ─────────────────────────────────────────────
    remove_foreign_key :favorites, :users
    add_foreign_key    :favorites, :users,      on_delete: :cascade

    remove_foreign_key :favorites, :specialties
    add_foreign_key    :favorites, :specialties, on_delete: :cascade

    # ── specialties ───────────────────────────────────────────
    # user 削除時は銘菓ごと cascade（User.has_many :specialties, dependent: :destroy と整合）
    remove_foreign_key :specialties, :users
    add_foreign_key    :specialties, :users,   on_delete: :cascade

    # region はマスタデータのため削除禁止
    remove_foreign_key :specialties, :regions
    add_foreign_key    :specialties, :regions, on_delete: :restrict

    # ── specialty_tags ────────────────────────────────────────
    remove_foreign_key :specialty_tags, :specialties
    add_foreign_key    :specialty_tags, :specialties, on_delete: :cascade

    remove_foreign_key :specialty_tags, :tags
    add_foreign_key    :specialty_tags, :tags,        on_delete: :cascade
  end

  def down
    remove_foreign_key :comments,      :users
    add_foreign_key    :comments,      :users

    remove_foreign_key :comments,      :specialties
    add_foreign_key    :comments,      :specialties

    remove_foreign_key :favorites,     :users
    add_foreign_key    :favorites,     :users

    remove_foreign_key :favorites,     :specialties
    add_foreign_key    :favorites,     :specialties

    remove_foreign_key :specialties,   :users
    add_foreign_key    :specialties,   :users

    remove_foreign_key :specialties,   :regions
    add_foreign_key    :specialties,   :regions

    remove_foreign_key :specialty_tags, :specialties
    add_foreign_key    :specialty_tags, :specialties

    remove_foreign_key :specialty_tags, :tags
    add_foreign_key    :specialty_tags, :tags
  end
end
