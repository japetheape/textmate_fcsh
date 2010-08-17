
class DirWatcher
  
  def initialize(dir, options = {}, &block)
    @dir = dir
    @block = block
    @sleep_time = options[:sleep_time] || 1
    run
  end
  
  def run
    while true
      new_run = `ls -lahRT #{@dir}`
      if new_run != @last_run
        on_change
      end
      @last_run = new_run
      sleep @sleep_time
    end
  end
  
  
  def on_change
    @block.call
  end
  
  
end