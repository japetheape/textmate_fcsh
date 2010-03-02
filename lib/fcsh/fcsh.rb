class Fcsh
  attr_reader :stdout, :stderr, :error_output_last_run
  
  def initialize(location)
    @targets = []
    @stdin, @stdout, @stderr = Open3.popen3(location)
    @error_output_last_run = ''
  end
  
  
  def compile(command)
    if !@targets.include?(command)
      errors = compile_first_time!(command) 
      if !errors.nil?
        puts errors
        exit
      end
      
    end
    puts "Compiling..."
    @error_output_last_run = ''
    @stdin.puts "compile %d" % [@targets.index(command) + 1]
    
    outfile = "bin/"
    
    # watch std out till files changed
    @stdout.each_line do |line|
      if /.+\.swf/.match(line)
        puts ""
        break
      end
      
      if /Files changed/.match(line)
        capture_error_output
        break
      end
    end
    #puts @error_output_last_run
    puts "Compiled."
  end
  
  # Create a target if this is the first time.
  def compile_first_time!(command)
    puts "Assigning target..."
    @stdin.puts command
    
    @mxmlc_errors = nil
    a = Thread.new do 
      @stderr.each_line do |line|
        
        if /Error: /.match(line) || !@mxmlc_errors.nil?
          @mxmlc_errors ||= "Errors while compiling, please check your .textmate_fcsh. Mxml output:\n"
          @mxmlc_errors << line
        end
      end
    end
    
    
    @targets << command
    sleep 3
    return @mxmlc_errors
  end
  
  # Currently there is no way of knowing when error output has finished,
  # so now we capture errors from start of receiving first line is 1 second 
  # ago or we started capturing error output is 4 seconds ago. Hope this
  # will be enough.
  def capture_error_output
    puts "Capturing error output"
    first_line_captured = nil
    started = Time.now
    a = Thread.new do 
      @stderr.each_line do |line|
        first_line_captured = Time.now if first_line_captured.nil?
        @error_output_last_run  << line
      end
    end
    
    loop do
      if (!first_line_captured.nil? && Time.now - first_line_captured > 1) || Time.now - started > 4
        break
      end
    end
    
  end
  
  
  
  
end