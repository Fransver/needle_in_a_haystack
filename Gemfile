env = ".env"
load(env) if File.exist?(env)

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "3.3.0"

gem "needle_in_a_haystack", path: "../fouriq_haystack" if defined?(USE_LOCAL_GEMS) && USE_LOCAL_GEMS

gem "bootsnap"
gem "rails"
gem "roo", "~> 2.10.0"
gem "timecop"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails", require: false
  gem "guard-bundler-audit", require: false
  gem "guard-rubocop", require: false
  gem "rspec"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov"
end

group :development do
  gem "listen"
end

group :test do
  gem "shoulda-matchers", require: false
end
