# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bitly-oauth/version"

Gem::Specification.new do |s|
  s.name             = "bitly-oauth"
  s.version          = BitlyOAuth::VERSION
  s.authors          = ["jonstorer"]
  s.email            = ["jonathon.scott.storer@gmail.com"]
  s.homepage         = "http://github.com/jonstorer/bitly-oauth"
  s.summary          = "Ruby wrapper for the Bitly V3 API with OAuth authentication."
  s.description      = "A ruby wrapper for version 3 of the bit.ly API\nSupports OAuth authentication\n"
  s.rubygems_version = "1.8.10"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]

  s.add_runtime_dependency('httparty')
  s.add_runtime_dependency('oauth2')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('rake')
  s.add_development_dependency('mocha')
  s.add_development_dependency('fakeweb')
end
