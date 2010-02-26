class Fcsh
  attr_reader :stdout, :stderr, :error_output_last_run
  
  def initialize(location)
    @targets = []
    @stdin, @stdout, @stderr = Open3.popen3(location)
    @error_output_last_run = ''
  end
  
  
  def compile(command)
    compile_first_time!(command) if !@targets.include?(command)
    puts "Compiling..."
    @error_output_last_run = ''
    @stdin.puts "compile %d" % [@targets.index(command) + 1]
    
    # watch std out till files changed
    @stdout.each_line do |line|
      #puts line.inspect 
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
    @targets << command
    sleep 3
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