#!/usr/bin/env rake
$:.push File.expand_path("../lib", __FILE__)
require "bitly_oauth/version"

require "bundler/gem_tasks"
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = BitlyOAuth::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bitly-oauth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => [:test]
