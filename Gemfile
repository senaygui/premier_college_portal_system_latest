source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
# gem 'wdm', '>= 0.1.0' if Gem.win_platform?
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'execjs'
# gem 'therubyracer'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# gem "sprockets-rails"
# gem 'turbolinks', '~> 5'
# gem 'hotwire-rails'
# gem 'importmap-rails'
# gem 'stimulus-rails'
# gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'redis-rails'
# Use ActiveModel has_secure_password
gem 'bcrypt'
gem "chartkick"
# gem "font-awesome-rails"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'jquery-rails'
gem 'jquery-datatables', '~> 1.10', '>= 1.10.20'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem 'devise'
gem 'activeadmin', '~> 2.9'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'activeadmin_addons', '~> 1.7', '>= 1.7.1'
gem 'active_admin_theme', '~> 1.1', '>= 1.1.4'
gem 'name_of_person', '~> 1.1', '>= 1.1.1'
gem 'cancancan', '~> 3.2', '>= 3.2.2'
gem 'country_select', '~> 3.1', '>= 3.1.1'
gem 'active_storage_drag_and_drop', '~> 1.1'
gem 'image_processing'
gem 'active_storage_validations', '~> 0.9.5'
gem 'bootstrap', '~> 4.6'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.7'
gem 'simple_form', '~> 5.0', '>= 5.0.2'
gem 'flatpickr', '~> 4.6', '>= 4.6.3.1'
gem 'nested_form'
gem 'whenever', require: false
gem "active_admin_import"
gem 'moodle_rb', '~> 2.1'
gem "rqrcode", "~> 2.1"
gem "chunky_png", "~> 1.4"
gem 'sidekiq'
gem 'matrix', '~> 0.4.2'
gem "barby", "~> 0.6.8"
gem 'active_admin_scoped_collection_actions'
gem 'active_admin_sidebar'
gem 'active_admin_flat_skin', github: 'ayann/active_admin_flat_skin'
# gem 'active_material'
# gem 'active_admin-subnav'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'prawn'
gem 'prawn-table', '~> 0.2.2'
# gem 'will_paginate'

group :development, :test do
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'capistrano-rails-db'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "rspec-rails"
  gem "rubocop"


  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen'


  # gem 'guard'
  # gem 'guard-livereload', '~> 2.4', require: false
  # gem 'rack-livereload'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]