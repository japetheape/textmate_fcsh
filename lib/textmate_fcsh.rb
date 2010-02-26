require 'tempfile'
require File.join(File.dirname(__FILE__), 'mxmlc_output', 'mxmlc_output_reader')
require File.join(File.dirname(__FILE__), 'formatters', 'html_mxmlc_error_formatter')
require File.join(File.dirname(__FILE__), 'file_watcher')

class TextmateFcsh
  
  def initialize
    write_to_tempfile("Waiting for run...")
    fcsh_bin = "/Developer/SDKs/flex_sdk_4-1/bin/fcsh "
    @fcsh = Fcsh.new(fcsh_bin)
    @file_watcher = FileWatcher.new('tmp/restart.txt')
    @file_watcher.each_change do |f|
      run
    end
  end
  
  
  def write_to_tempfile(txt)
    @report_file = File.new('/tmp/mxmlc_error_report.html', 'w+')
    @report_file.write(txt)
    @report_file.close
  end
  
  def open_browser
    `open #{@report_file.path}`
  end
  
  def run
    output = run_mxmlc
    @mxml_output_reader = MxmlcOutputReader.new(output)
    @report = HtmlMxmlcErrorFormatter.new(@mxml_output_reader.errors)
    write_report!
    open_browser
  end
  
  
  def run_mxmlc
    mxmlc_command = "mxmlc -default-background-color=#FFFFFF -default-frame-rate=24 -default-size 970 550 -output=bin/editor-debug.swf -source-path+=src -source-path+=assets -source-path+=lib/mvc -source-path+=lib/editor_core -verbose-stacktraces=true -warnings=true src/editor.mxml"
    @fcsh.compile(mxmlc_command)
    @fcsh.error_output_last_run
  end
  
  def run_bogus_mxmlc
    out = ''
    mxmlc_output_file = File.join(File.dirname(__FILE__), '..', 'spec', 'fixtures', 'mxmlc_output.txt')
    File.open(mxmlc_output_file).each_line {|l| out << l}
    out
  end
  

  def write_report!
    write_to_tempfile(@report.out)
  end
  
  
end