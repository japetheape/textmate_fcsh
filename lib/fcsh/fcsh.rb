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
      puts "FCSH OUT: " + line.inspect if $DEBUG
      
      if /.+\.swf/.match(line)
        puts ""
        break
      end
      
      if /Nothing has changed/.match(line)
        puts "Nothing has changed"
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
    @stdin.puts command if $DEBUG
    
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
    last_line_captured = nil
    started = Time.now
    a = Thread.new do 
      @stderr.each_line do |line|
        puts "FCSH ERROR: " + line.inspect  if $DEBUG
        last_line_captured = Time.now
        @error_output_last_run  << line
      end
    end
    
    loop do
      if (!last_line_captured.nil? && Time.now - last_line_captured > 3)
        break
      end
    end
    
  end
  
  
  
  
end