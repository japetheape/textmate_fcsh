# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{textmate_fcsh}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jaap van der Meer"]
  s.date = %q{2010-03-02}
  s.default_executable = %q{textmate_fcsh}
  s.description = %q{Compile Flex in Textmate using FCSH. Advanced error reporting.}
  s.email = %q{jaapvandermeer@gmail.com}
  s.executables = ["textmate_fcsh"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/textmate_fcsh",
     "lib/fcsh/fcsh.rb",
     "lib/file_watcher.rb",
     "lib/formatters/html_mxmlc_error_formatter.rb",
     "lib/mxmlc_output/mxmlc_error.rb",
     "lib/mxmlc_output/mxmlc_output_reader.rb",
     "lib/textmate_fcsh.rb",
     "spec/fixtures/mxmlc_output.txt",
     "spec/html_mxmlc_error_formatter_spec.rb",
     "spec/mxmlc_output_reader_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/textmate_fcsh_spec.rb",
     "templates/standard.html.erb",
     "textmate_fcsh.gemspec"
  ]
  s.homepage = %q{http://github.com/japetheape/textmate_fcsh}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Compile Flex in Textmate using FCSH. Advanced error reporting.}
  s.test_files = [
    "spec/html_mxmlc_error_formatter_spec.rb",
     "spec/mxmlc_output_reader_spec.rb",
     "spec/spec_helper.rb",
     "spec/textmate_fcsh_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

