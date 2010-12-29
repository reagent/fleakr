require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require File.expand_path('../lib/fleakr/version', __FILE__)

spec = Gem::Specification.new do |s|
  s.name             = 'fleakr'
  s.version          = Fleakr::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A small, yet powerful, gem to interface with Flickr photostreams"
  s.author           = 'Patrick Reagan'
  s.email            = 'reaganpr@gmail.com'
  s.homepage         = 'http://fleakr.org'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib,test}/**/*")

  s.add_dependency('hpricot', '>= 0.6.164')
  s.add_dependency('activesupport', '~> 2.3.0')
  s.add_dependency('loggable', '>= 0.2.0')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Install this Gem'
task :install => :gem do
  sh "gem install pkg/#{spec.full_name}.gem"
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

begin
  require 'rcov/rcovtask'

  desc 'Run tests with code coverage statistics'
  Rcov::RcovTask.new(:coverage) do |t|
    t.libs       = ['test']
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose    = true
    t.rcov_opts  = ['--text-report', "-x #{Gem.path}", '-x /Library/Ruby', '-x /usr/lib/ruby', "-x #{ENV['HOME']}/.rvm"]
  end

  task :default => :coverage

rescue LoadError
  desc 'Run tests with code coverage statistics'
  task(:coverage) { $stderr.puts 'Run `gem install rcov` to get coverage stats' }
  task :default => :test
end

desc 'Generate the gemspec for this Gem'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end