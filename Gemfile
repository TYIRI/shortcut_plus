source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.7.2'

gem 'rails', '6.1.3.1'

# Database
gem 'mysql2', '~> 0.5'

# Application server
gem 'puma', '~> 5.0'

# Assets
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Configuration
gem 'config'
gem 'dotenv-rails'

# UI/UX
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'html2slim'
gem 'jbuilder', '~> 2.7'
gem 'rails-i18n', '~> 6.0'
gem 'meta-tags'

# Form
gem 'simple_form'

# Authentication
gem 'pundit'
gem 'sorcery'
gem 'bcrypt', '~> 3.1.16'

# Pagenation
gem 'kaminari'

# Analytics
gem 'impressionist',
  git: 'git@github.com:charlotte-ruby/impressionist.git',
  ref: '46a582ff8cd3496da64f174b30b91f9d97e86643'

# Storage
gem 'mini_magick'
gem 'image_processing', '~> 1.2'
gem 'aws-sdk-s3', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Email
  gem 'letter_opener_web'

  # CLI
  gem 'spring-commands-rspec'

  # Test
  gem 'factory_bot_rails'
  gem 'rspec-rails'

  # Code analyze
  gem 'rubocop'
  gem 'rubocop-rails'

  # Debugger
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

group :production, :staging do
  gem 'unicorn', '5.4.1'
end
