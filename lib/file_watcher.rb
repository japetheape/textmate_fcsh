class FileWatcher
  def initialize(file)
    @file = file
    create!
  end
  
  # Creates file if not exists
  def create!
    if(!File.exist?(@file))
      FileUtils.mkdir_p(@file)
      FileUtils.touch(@file)
    end
  end
  
  def each_change(&block)
    last_stat = nil
    loop do
      out = `stat #{@file}`
      if out != last_stat
        last_stat = out
        yield block
      end
      sleep 0.5
    end
    
  end
end