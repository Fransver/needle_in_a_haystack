source "https://rubygems.org"

# Runtime dependencies are declared in the gemspec.
gemspec

# Rails meta-gem is used to boot the test/dummy application.
gem "rails", "~> 7.1"
gem "bootsnap", require: false

group :development, :test do
  gem "dotenv-rails"
  gem "factory_bot_rails", require: false
  gem "mysql2"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov", require: false
end

group :test do
  gem "shoulda-matchers", require: false
end

group :development do
  gem "listen"
end
