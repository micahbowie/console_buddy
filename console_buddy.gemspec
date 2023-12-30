
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "console_buddy/version"

Gem::Specification.new do |spec|
  spec.name          = "console_buddy"
  spec.version       = ConsoleBuddy::VERSION
  spec.authors       = ["Micah Bowie", "Code Cowboy"]
  spec.email         = ["micahbowie20@gmail.com"]

  spec.summary       = 'Console Buddy allows you to use dozens of helpful console methods, shortcuts, and helpers. You can also define custom helpers for your application that will always be loaded in your Rails console when you need it.'
  spec.description   = 'Console Buddy allows you to use dozens of helpful console methods, shortcuts, and helpers. You can also define custom helpers for your application that will always be loaded in your Rails console when you need it.'

  spec.files = Dir['lib/**/*'] + Dir['spec/**/*']

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/micahbowie/console_buddy/issues",
    "changelog_uri"     => "https://github.com/micahbowie/console_buddy/CHANGELOG.md",
    "documentation_uri" => "https://github.com/micahbowie/console_buddy",
    "source_code_uri"   => "https://github.com/micahbowie/console_buddy",
  }

  spec.required_ruby_version = ">= 2.0"
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails'
  # spec.add_dependency 'httparty'

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
end
