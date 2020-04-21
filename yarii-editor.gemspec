$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "yarii-editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "yarii-editor"
  spec.version     = YariiEditor::VERSION
  spec.authors     = ["Jared White"]
  spec.email       = ["jared@jaredwhite.com"]
  spec.homepage    = "https://whitefusion.io"
  spec.summary     = "Provides a editing admin interface to any Rails app for handling static content (aka Jekyll)"
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.files = Dir["{app,bin,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.0"
  spec.add_dependency "webpacker", "~> 4.0"
  spec.add_dependency "git", "~> 1.5"
end
