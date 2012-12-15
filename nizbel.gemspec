$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nizbel/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "Nizbel"
  s.version     = Nizbel::VERSION
  s.authors     = ["Michael D. Tighe"]
  s.email       = ["striderIIDX@gmail.com"]
  s.homepage    = "mtighe.herokuapp.com"
  s.summary     = "Usenet indexer"
  s.description = "Scrapes newsgroups, indexes content, makes piracy better."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "railties", "~> 3.2"
  s.add_dependency "rails", "~> 3.2.9"
  s.add_dependency "haml-rails"
  s.add_dependency 'sass-rails', '~> 3.2'
  s.add_dependency 'bootstrap-sass', '~> 2.2.1.1'
  s.add_dependency 'bcrypt-ruby'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
