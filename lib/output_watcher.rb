class OutputWatcher
  attr_reader :stdout, :stderr
  
  def initialize(command)
    @stderr = ''
    @stdout = ''
    
    Open3.popen3(command) do |stdin, stdout, stderr|
      stderr.each_line { |line| @stderr << line }
      stdout.each_line { |line| @stdout << line }
    end
  end
  
  
end