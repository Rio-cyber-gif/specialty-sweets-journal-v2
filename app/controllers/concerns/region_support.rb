# frozen_string_literal: true

# 地域選択フォーム用のグループ定義・ヘルパーメソッド
module RegionSupport
  extend ActiveSupport::Concern

  # 地方ブロックと都道府県IDの対応（地図SVGから渡されるパラメータ）
  REGION_BLOCKS = {
    'tohoku' => [2, 3, 4, 5, 6, 7],
    'kanto' => [8, 9, 10, 11, 12, 13, 14],
    'chubu' => [15, 16, 17, 18, 19, 20, 21, 22, 23],
    'kinki' => [24, 25, 26, 27, 28, 29, 30],
    'chugoku' => [31, 32, 33, 34, 35],
    'shikoku' => [36, 37, 38, 39],
    'kyushu' => [40, 41, 42, 43, 44, 45, 46, 47]
  }.freeze

  # 地方ブロック名（表示用）
  REGION_BLOCK_NAMES = {
    'tohoku' => '東北',
    'kanto' => '関東',
    'chubu' => '中部',
    'kinki' => '近畿',
    'chugoku' => '中国',
    'shikoku' => '四国',
    'kyushu' => '九州・沖縄'
  }.freeze

  # フォーム用：地方グループ → 都道府県ID一覧（DB不要・固定知識）
  REGION_GROUPS = {
    '北海道' => [1],
    '東北' => [2, 3, 4, 5, 6, 7],
    '関東' => [8, 9, 10, 11, 12, 13, 14],
    '中部' => [15, 16, 17, 18, 19, 20, 21, 22, 23],
    '近畿' => [24, 25, 26, 27, 28, 29, 30],
    '中国' => [31, 32, 33, 34, 35],
    '四国' => [36, 37, 38, 39],
    '九州・沖縄' => [40, 41, 42, 43, 44, 45, 46, 47]
  }.freeze

  private

  # フォーム用：地方グループ別に Region レコードをまとめる
  def build_grouped_regions
    all_regions = Region.all.index_by(&:id)
    REGION_GROUPS.filter_map do |group_name, ids|
      regions = ids.filter_map { |id| all_regions[id] }
      next if regions.empty?

      [group_name, regions.map { |r| [r.name, r.id] }]
    end
  end
end
