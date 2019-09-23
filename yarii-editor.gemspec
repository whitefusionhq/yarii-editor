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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.0"
  spec.add_dependency "webpacker", "~> 4.0"

  spec.add_development_dependency "sqlite3"
end
