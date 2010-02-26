$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'textmate_fcsh'
require 'mxmlc_output/mxmlc_output_reader'
require 'formatters/html_mxmlc_error_formatter'



require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
