if defined? RSpec
  RSpec.configure do |config|
    config.before(:suite) do
      ConsoleBuddy.start! if ConsoleBuddy.use_in_tests
      ConsoleBuddy.load_byebug! if ConsoleBuddy.use_in_debuggers
    end
  end
end