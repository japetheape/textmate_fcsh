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
    gem.add_dependency "ruby-growl"
    gem.bindir = 'bin'
    gem.executables = ["textmate_fcsh"]
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
  rdoc.title = "textmate_fcsh #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
