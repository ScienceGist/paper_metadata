# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paper_metadata/version'

Gem::Specification.new do |gem|
  gem.name          = "paper_metadata"
  gem.version       = PaperMetadata::VERSION
  gem.authors       = ["Jure Triglav"]
  gem.email         = ["juretriglav@gmail.com"]
  gem.summary   = %q{Paper_metadata gem gets the metadata for papers with a DOI or an arXiv identifier}
  gem.description       = %q{Metadata getter for scientific papers}
  gem.homepage      = "http://github.com/jure/paper_metadata"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock"
  gem.add_runtime_dependency "nokogiri", ["= 1.5.6"]

end
