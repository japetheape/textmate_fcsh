class Fcsh
  attr_reader :stdout, :stderr, :error_output_last_run
  
  
  
  def initialize(location)
    @targets = []
    @stdin, @stdout, @stderr = Open3.popen3(location)
    @error_output_last_run = ''
    
    @error_collector_thread = Thread.new do
      Thread.stop
      capture_error_output
    end
  end
  
  
  
  
  def compile(command)
    compile_first_time!(command) if !@targets.include?(command)
    puts "Compiling..."
    @stdin.puts "compile %d" % [@targets.index(command) + 1]
    
    @error_output_last_run = ''
    @error_collector_thread.run
    # watch std out till files changed
    @stdout.each_line do |line|
      if /Files changed/.match(line)
        break
      end
    end
    
    puts "Compiled."
  end
  
  
  def compile_first_time!(command)
    puts "Assigning target..."
    @stdin.puts command
    @targets << command
    sleep 3
  end
  
  
  def capture_error_output
    puts "Capturing error output"
    @stderr.each_line do |line|
      @error_output_last_run  << line
    end
  end
  
  
  
  
end