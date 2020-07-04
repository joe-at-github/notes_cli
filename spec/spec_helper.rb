# frozen_string_literal: true

require 'simplecov'
require 'fakefs/safe'

SimpleCov.start

RSpec.configure do |config|
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each do |f| 
    require f
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.default_formatter = 'doc'

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
