# coding: utf-8
require File.expand_path('../lib/enchanted_quill/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "enchanted_quill"
  spec.version       = EnchantedQuill::VERSION
  spec.authors       = ["Elom Gomez"]
  spec.email         = ["gomezelom@yahoo.com"]

  spec.summary       = %q{RubyMotion port of ActiveLabel.swift}
  spec.description   = %q{Drop in replacement for UILabel with support for mentions, links and hashtags}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files << 'LICENSE.txt'
  files << 'CODE_OF_CONDUCT.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files          = files
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake'
end
