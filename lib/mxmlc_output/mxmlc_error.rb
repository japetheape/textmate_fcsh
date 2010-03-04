class MxmlcError
  attr_reader :filename, :line, :column, :level, :message, :content
  
  LEVEL_WARN = :warn
  LEVEL_ERROR = :error
  

  
  def initialize(filename, line, column, level, message)
    @filename = filename
    @line = line
    @column = column
    @level = level
    @message = message
    @content = ''
  end
  

  
  
end