# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'iso_1996'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
