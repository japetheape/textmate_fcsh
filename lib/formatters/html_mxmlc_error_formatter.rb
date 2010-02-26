require 'erb'


class HtmlMxmlcErrorFormatter

  attr_reader :out, :errors
  
  def initialize(errors, template = nil)
    @errors = errors
    @template_file = template || File.join(File.dirname(__FILE__), '..', '..', 'templates', 'standard.html.erb')
    @out = format!
  end
  
  def format!
    template = ''
    File.open(@template_file).each_line { |l| template << l }
    formatted = ERB.new(template, 0, '%<>')
    formatted.result(binding)
  end
  
end