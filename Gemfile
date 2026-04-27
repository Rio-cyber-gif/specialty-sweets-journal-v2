# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

gem 'bootsnap', require: false
gem 'concurrent-ruby', '1.3.4'
gem 'image_processing', '~> 1.2' # Active Storage用（既存）
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 8.0'
gem 'rails', '~> 7.2.0'
gem 'redis', '>= 4.0.1'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# specialty-sweets-journal用機能gem
gem 'devise'
gem 'devise-i18n'
gem 'draper', '4.0.2'
gem 'rails-i18n', '~> 7.0.0'
# gem 'carrierwave', '~> 2.2'
gem 'bootstrap', '~> 5.2'
gem 'cloudinary'
gem 'jquery-rails'
gem 'kaminari'
gem 'ransack', '~> 4.2'
# gem 'mini_magick', '~> 4.11'  # image_processingが代替）
# gem 'marcel', '~> 1.0'        # コメントアウト（Rails標準）

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter'
  gem 'rubocop-rails'
end

group :development do
  gem 'brakeman', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
