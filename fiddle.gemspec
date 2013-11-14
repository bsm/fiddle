require File.expand_path("../lib/fiddle/version", __FILE__)

# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "fiddle"
  s.summary     = "Fiddle"
  s.description = "Rails Engine for constructing universes"
  s.version     = Fiddle::VERSION.dup

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/fiddle"
  s.license     = ['MIT']

  s.files       = Dir["{app,lib,config}/**/*"]
  s.test_files  = Dir["{spec}/**/*", "Rakefile", "Gemfile*"]

  s.add_dependency "railties", ">= 3.1.0", "< 4.1.0"
  s.add_dependency "activerecord", ">= 3.1.0", "< 4.1.0"
  s.add_dependency "sequel", ">= 4.4.0", "< 5.0.0"
  s.add_dependency "inherited_resources"

  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
  s.add_development_dependency "factory_girl"
end
