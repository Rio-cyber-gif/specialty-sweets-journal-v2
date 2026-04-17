# CLOUDINARY_URL がある場合はそちらを優先（Heroku add-on 等）
# ない場合は個別の環境変数から設定
unless ENV['CLOUDINARY_URL'].present?
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
    config.secure     = true
  end
end
