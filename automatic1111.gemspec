# frozen_string_literal: true

require_relative "lib/automatic1111/version"

Gem::Specification.new do |spec|
  spec.name = "automatic1111"
  spec.version = Automatic1111::VERSION
  spec.authors = ["Dreaming Tulpa"]
  spec.email = ["hey@dreamingtulpa.com"]

  spec.summary = "Automatic1111 Ruby API Wrapper"
  spec.homepage = "https://github.com/dreamingtulpa/automatic1111-ruby"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dreamingtulpa/automatic1111-ruby"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "faraday-retry"
  spec.add_dependency "faraday-multipart"
  spec.add_dependency "addressable"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
