
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "literal_enums/version"

Gem::Specification.new do |spec|
  spec.name          = "literal_enums"
  spec.version       = LiteralEnums::VERSION
  spec.authors       = ["Joel Drapper"]
  spec.email         = ["joel@drapper.me"]

  spec.summary       = "Literal Enums syntax for Ruby"
  spec.description   = "A comprehensive Enum library for Ruby with literal-style syntax."
  spec.homepage      = "https://github.com/joeldrapper/literal_enums"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joeldrapper/literal_enums"
  spec.metadata["changelog_uri"] = "https://github.com/joeldrapper/literal_enums"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3.7"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "activesupport", "~> 7.0.2.2"
end
