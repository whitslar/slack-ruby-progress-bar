# frozen_string_literal: true

require_relative "lib/slack_progress_bar/version"

Gem::Specification.new do |spec|
  spec.name          = "slack_progress_bar"
  spec.version       = SlackProgressBar::VERSION
  spec.authors       = ["Matt Whitslar"]
  spec.email         = ["matt.whitslar@gmail.com"]

  spec.summary       = "Create Progress Bars on Slack"
  spec.homepage      = "https://github.com/whitslar/slack_progress_bar"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/whitslar/slack_progress_bar"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "slack-ruby-client"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
