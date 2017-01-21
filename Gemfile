source 'https://rubygems.org'

ruby(File.read(".ruby-version").strip) if File.exist?(".ruby-version")

gem 'rails', '~> 5.0.1', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'attr_encrypted'
gem 'countries'
gem 'aasm'
gem 'responders'
gem 'validate_url', :github => "perfectline/validates_url"
gem 'money-rails'
gem 'twilio-ruby'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootswatch-rails'
gem 'haml-rails'
gem 'font-awesome-rails'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end
