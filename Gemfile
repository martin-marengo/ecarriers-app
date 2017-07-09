source 'https://rubygems.org'

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'paperclip', '~> 5.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use Boostrap
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
# Use font awesome
gem 'font-awesome-rails'
gem 'bootstrap-select-rails'

# Manejo de usuarios
gem 'devise'

# Wizard in shipment publication
gem 'wicked'

# endless pagination
gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-will_paginate'

gem 'money-rails'

gem 'delayed_job_active_record'

# Facebook integration
gem 'omniauth'
gem 'omniauth-facebook'

# API Doc generator
gem 'apipie-rails'

# To be able to use rails console
gem 'rb-readline'

# Carrier revenue chart
gem "chartkick"

# AWS services for storaging some assets and paperclip images.
gem 'aws-sdk', '~> 2.3'

# Template required: https://github.com/rocsci/jquery-easing-rails
# Por ahora esta gema se reemplaza por el archivo javascripts/custom/easing-jquery-plugin.js
#gem 'jquery-easing-rails'

group :development, :test do
  gem 'byebug'
end

group :test do
  # Used to execute pipelines in BitBucket
  gem 'therubyracer', platforms: :ruby

  gem 'sqlite3'
  
  gem 'simplecov', :require => false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'rubocop', require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # To see better errors when something fails
  gem 'better_errors'
  gem 'binding_of_caller'

  # To generate ERD
  gem 'rails-erd'
end

group :production do
  # Enable static asset serving and logging on Heroku
  gem 'rails_12factor'
end