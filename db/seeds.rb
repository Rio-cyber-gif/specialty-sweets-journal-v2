puts '=========================================='
puts '地域データの作成を開始します...'
puts '=========================================='

regions = %w[
  北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県
  茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
  新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県
  静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県
  奈良県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県
  徳島県 香川県 愛媛県 高知県 福岡県 佐賀県 長崎県
  熊本県 大分県 宮崎県 鹿児島県 沖縄県
]

regions.each do |name|
  Region.find_or_create_by!(name: name)
end

puts " #{Region.count}件の地域データを登録しました"
puts '=========================================='
puts '管理者アカウントの作成を開始します...'
puts '=========================================='

# 管理者アカウント（存在しない場合のみ作成）
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.name = '管理者'
  user.role = :admin  # roleカラムがある場合
end

puts " 管理者アカウント: #{admin.email}"
puts "   ID: #{admin.id}"
puts "   Role: #{admin.role}"
puts '=========================================='
puts '管理者アカウントの作成が完了しました!'
puts '=========================================='