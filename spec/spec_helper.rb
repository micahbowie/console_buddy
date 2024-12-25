require "bundler/setup"
require "byebug"
require 'rails'

require "console_buddy"

ENV['RAILS_ENV'] ||= 'test'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


# RSpec.configure do |config|
#   config.expect_with :rspec do |expectations|
#     expectations.include_chain_clauses_in_custom_matcher_descriptions = true
#   end

#   config.mock_with :rspec do |mocks|
#     mocks.verify_partial_doubles = true
#   end

#   config.shared_context_metadata_behavior = :apply_to_host_groups
# end