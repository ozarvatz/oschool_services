require "rack/test"
require_relative '../spora_service_api.rb'

#TODO - clear test dbs

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.order = :random
  config.tty = true
  config.formatter = :documentation 
  config.expect_with :rspec do |expectations|
    expectations.syntax = :should
  end  
end