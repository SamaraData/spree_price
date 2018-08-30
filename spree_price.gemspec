# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_price/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_price'
  s.version     = SpreePrice.version
  s.summary     = 'Flexible price for spree'
  s.description = ''
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Charles Wong'
  s.email     = 'charles@eoniq.co'
  s.homepage  = 'https://github.com/EONIQ/spree_price'
  s.license = 'BSD-3-Clause'

  s.files        = Dir['README.md', 'lib/**/*', 'app/**/*', 'config/**/*', 'db/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0'
  s.add_dependency 'money-open-exchange-rates', '1.2.0'
  s.add_dependency 'validates_timeliness', '~> 3.0'
  s.add_dependency 'spree_request_store'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-given'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
end
