require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/fleakr/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'fleakr'
  s.version          = Fleakr::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.markdown)
  s.summary          = "A teeny tiny gem to interface with Flickr photostreams"
  s.author           = 'Patrick Reagan'
  s.email            = 'reaganpr@gmail.com'
  s.homepage         = 'http://sneaq.net'
  s.files            = %w(README.markdown Rakefile) + Dir.glob("{lib,test}/**/*")
  # s.executables    = ['fleakr']
  
  s.add_dependency('hpricot', '~> 0.6.0')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end