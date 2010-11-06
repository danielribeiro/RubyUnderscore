require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'

task :default => [:spec]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rubyunderscore"
    gem.summary = %Q{Simple way to create simple blocks}
    gem.description = %Q{It allows you to create simple blocks by using underscore symbol}
    gem.email = "danrbr+rubyunderscore@gmail.com"
    gem.homepage = "http://github.com/danielribeiro/RubyUnderscore"
    gem.authors = ["Daniel Ribeiro"]
    gem.add_dependency 'ParseTree', '=3.0.5'
    gem.add_dependency 'ruby2ruby'
    gem.files = FileList["[A-Z]*", "{bin,lib}/**/*"]
#    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rubyunderscore #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.libs << Dir["lib"]
end