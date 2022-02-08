# frozen_string_literal: true

src = File.expand_path("src", __dir__)
$LOAD_PATH.unshift(src) unless $LOAD_PATH.include?(src)
require "streem/version"

Gem::Specification.new do |spec|
  spec.name = "streem"
  spec.version = Streem::VERSION
  spec.authors = ["Streem Dev"]
  spec.email = ["dev@streem.pro"]

  spec.summary = "Streem SDK"
  spec.description = "Streem library to interact with the Streem API and generate Embedded SSO tokens"
  spec.homepage = "https://streem.pro"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/streem/streem-sdk-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/streem/streem-sdk-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = ["src/streem.rb", "src/streem/version.rb", "src/streem/token_builder.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["src"]

  spec.add_runtime_dependency "jose", ["= 1.1.3"]
end
