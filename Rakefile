require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "textmate_fcsh"
    gem.summary = "Compile Flex in Textmate using FCSH. Advanced error reporting."
    gem.description = "Compile Flex in Textmate using FCSH. Advanced error reporting."
    gem.email = "jaapvandermeer@gmail.com"
    gem.homepage = "http://github.com/japetheape/textmate_fcsh"
    gem.authors = ["Jaap van der Meer"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "fcsh"
    gem.add_dependency "em-websocket"
    gem.add_dependency "json"
    gem.bindir = 'bin'
    gem.executables = ["textmate_fcsh"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "textmate_fcsh #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
