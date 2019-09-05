# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

source 'https://rails-assets.org' do
  # Bootstrap tooltips and popovers require tether
  # http://tether.io/
  gem 'rails-assets-tether', '>= 1.3.3'
end

# Ruby
# https://github.com/ruby/ruby
ruby '2.5.3'
# Ruby on Rails
# https://github.com/rails/rails
gem 'rails', '~> 5.1.4'
# Ruby interface to the PostgreSQL RDBMS
# https://bitbucket.org/ged/ruby-pg
gem 'pg', '~> 0.18'
# A Ruby/Rack web server built for concurrency
# https://github.com/puma/puma
gem 'puma', '~> 3.0'
# Sass adapter for the Rails asset pipeline
# https://github.com/rails/sass-rails
gem 'sass-rails', '~> 5.0'
# Minifies JavaScript files by wrapping UglifyJS to be accessible in Ruby
# https://github.com/lautis/uglifier
gem 'uglifier', '>= 1.3.0'
# CoffeeScript adapter for the Rails asset pipeline
# https://github.com/rails/coffee-rails
gem 'coffee-rails', '~> 4.2'

group :development, :test do
  # A Ruby debugger to stop execution and get a debugger console
  # https://github.com/deivid-rodriguez/byebug
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  # https://github.com/rails/web-console
  gem 'web-console', '>= 3.3.0'
  # Listens to file modifications and notifies you about the changes
  # https://github.com/guard/listen
  gem 'listen', '~> 3.0.5'
  # A Ruby static code analyzer, based on the community Ruby style guide
  # https://github.com/bbatsov/rubocop.
  gem 'rubocop', require: false
  # Speeds up development by keeping your application running in the background
  # https://github.com/rails/spring
  gem 'spring'
  # Makes Spring watch the filesystem using Listen instead of polling
  # https://github.com/jonleighton/spring-watcher-listen
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # A library for setting up Ruby objects as test data.
  # https://github.com/thoughtbot/factory_bot
  gem 'factory_bot'
  # A complete suite of testing facilities
  # https://github.com/seattlerb/minitest
  gem 'minitest', '5.10.1'
  # Record your test suite's HTTP interactions and replay them during test runs
  # https://github.com/vcr/vcr
  gem 'vcr'
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  # https://github.com/bblimke/webmock
  gem 'webmock'
end

# A library for bulk insertion of data into your database using ActiveRecord
# https://github.com/zdennis/activerecord-import
gem 'activerecord-import'
# Bootstrap 4 Ruby Gem for Rails.
# https://github.com/twbs/bootstrap-rubygem
gem 'bootstrap'
# A Ruby gem to load environment variables from .env
# https://github.com/bkeepers/dotenv
gem 'dotenv-rails'
# Create pretty URL's and work with human-friendly strings.
# https://github.com/norman/friendly_id
gem 'friendly_id'
# Ruby lib for dealing with GTFS.
# https://github.com/nerdEd/gtfs
gem 'gtfs'
# Build JSON APIs with ease
# https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Automate using jQuery with Rails
# https://github.com/rails/jquery-rails
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster
# https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
