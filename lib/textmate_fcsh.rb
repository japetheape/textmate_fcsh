require 'rubygems'
require File.join(File.dirname(__FILE__), 'dir_watcher')

require 'tempfile'
require File.join(File.dirname(__FILE__), 'formatters', 'html_mxmlc_error_formatter')
require 'yaml'
require File.join(File.dirname(__FILE__), 'output_watcher')
require File.join(File.dirname(__FILE__), 'websocket_server')
require 'fcsh'
require 'em-websocket'
require 'json'
require 'ruby-growl'

class TextmateFcsh
  CONFIG_FILE = '.textmate_fcsh'
  TEXTMATE_BUNDLE_LOCATION = "git://github.com/japetheape/textmate_fcsh_bundle.git"
  
  def initialize(options = {})
    @options = options
    @server = WebsocketServer.new
    open_browser_first_time
    @growl = Growl.new "127.0.0.1", "ruby-growl", ["ruby-growl Notification"]
    
    check_preconditions
    read_config!
    write_to_tempfile("Waiting for run...")
  
    if options[:standalone]
      puts "Running standalone"
      run
    else
      @fcsh = Fcsh.new
      d = DirWatcher.new(@config[:mxmlc_options][:source_path].split(",").join(' ')) do 
        run
      end
    end
  end
  
  
  
  
  
  
  # Write report to file
  def write_to_tempfile(txt)
    @report_file = File.new('/tmp/mxmlc_error_report.html', 'w+')
    @report_file.write(txt)
    @report_file.close
  end
  
  def open_browser_first_time
    if !@options[:standalone]
      f = File.join(File.dirname(__FILE__), '..','templates', 'standard.html')
      `open #{f}`
    end
  end
  
  # Open the report in the browser
  def open_browser
    `open #{@report_file.path}`
  end
  
  # Compile the mxmlc, extract errors, create a report.
  def run
    if @options[:standalone]
      puts get_compile_command
      output_watcher = OutputWatcher.new("mxmlc " + get_compile_command)
      output_watcher.stdout.each_line do |line|
        puts " -->\t" + line
      end
      
      output = output_watcher.stderr
      errors = MxmlcOutputReader.new(output)
      
      @report = HtmlMxmlcErrorFormatter.new(errors)
      write_report!
      open_browser
      
    else
      output = run_mxmlc
      errors = @fcsh.errors
      
      message = "Complete: %d errors, %d warnings" % [errors.errors.size, errors.warnings.size]
      puts message
      error_array = errors.messages.map {|x| {"filename" => x.filename, "line" => x.line, "level" => x.level, "message" => x.message, "content" => x.content, "column" => x.column } }
      @server.send  JSON.generate(error_array)
      @growl.notify "ruby-growl Notification", "Textmate FCSH", message
    end
    

      
  end
  
  def get_compile_command
    mxmlc_command = ""
    #" -default-background-color=#FFFFFF -default-frame-rate=24 -default-size 970 550 -output=bin/editor-debug.swf -source-path+=src -source-path+=assets -source-path+=lib/mvc -source-path+=lib/editor_core -verbose-stacktraces=true -warnings=true src/editor.mxml"
    @config[:mxmlc_options].each do |k,v|
      #next if v
      splitted = v.to_s.split(",")
      splitted.each do |vsplitted|
        splitter =  splitted.length > 1 ? '+=' : '='
        if k == :default_size
          splitter = ' '
        end
        if k == :library_path
          splitter = '+='
        end
        mxmlc_command << " -%s%s%s" % [k.to_s.gsub(/\_/, '-'),splitter,vsplitted]
      end
    end
    mxmlc_command << " %s" % @config[:main_file]
    mxmlc_command
  end
  
  # Runs the mxmlc in the fcsh compiler
  def run_mxmlc
    if @target_id.nil?
      @target_id = @fcsh.mxmlc(get_compile_command)
    else
      @fcsh.compile(@target_id)
    end
  end
  
  # Run a bogus mxmlc command, not used anymore.
  def run_bogus_mxmlc
    out = ''
    mxmlc_output_file = File.join(File.dirname(__FILE__), '..', 'spec', 'fixtures', 'mxmlc_output.txt')
    File.open(mxmlc_output_file).each_line {|l| out << l}
    out
  end
  
  
  def write_report!
    write_to_tempfile(@report.out)
  end
  
  
  def check_preconditions
    raise "Configuration file does not exist, first run textmate_fcsh --setup" if !File.exist?(CONFIG_FILE)
  end
  
  
  # Read configurion file, stored in .textmate_fcsh
  def read_config!
    @config = YAML.load_file(CONFIG_FILE)
  end
  
  
  # Create the config file
  def self.create_config!
    if File.exist?(CONFIG_FILE)
      raise "Before recreating, first remove %s" % CONFIG_FILE
    end
    example_config = {:mxmlc_options => {:default_background_color => '#FFFFFF', :default_frame_rate => 24, :default_size => "970 550", :output => "bin/project-debug.swf", :source_path => "src,assets,lib/mvc,lib/editor_core", :verbose_stacktraces => true, :warnings => true}}
    example_config[:main_file] = 'src/editor.mxml'
    
    File.open('.textmate_fcsh', 'w+') do |f|
      f.write(YAML::dump(example_config))
    end
  end
  
  # Clones the textmate bundle
  def self.create_textmate_bundle!
    puts "Installing textmate bundle."
    `mkdir -p ~/Library/Application\\ Support/TextMate/Bundles`
    `cd ~/Library/Application\\ Support/TextMate/Bundles/ && git clone #{TEXTMATE_BUNDLE_LOCATION} "textmate_fcsh.tmbundle"`
    `osascript -e 'tell app "TextMate" to reload bundles'`
    puts "Textmate bundle installed."
  end
  
  
end