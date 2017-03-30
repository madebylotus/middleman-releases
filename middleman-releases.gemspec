# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-releases"
  s.version     = "0.3.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Millsaps-Brewer"]
  s.email       = ["matt@madebylotus.com"]
  s.homepage    = "http://www.madebylotus.com"
  s.summary     = %q{Provides a way to define software downloads in your project}
  s.description = %q{Manage a directory of software releases in your project}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.0.0"])

  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
