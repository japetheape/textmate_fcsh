require File.join(File.dirname(__FILE__), 'mxmlc_error')


# Formats the mxmlc to errors
class MxmlcOutputReader
  attr_reader :errors
  ERROR_LINE = /^((\/([\w\.]+))+)(\((-?\d+)\))?:\s*(col: (\d+))?:?\s*(Error|Warning+): (.+)$/

  def initialize(output)
    @output = output
    @errors = []
    parse!
  end
  
  
  # example: /Users/japetheape/Projects/tunedustry/editor/src/com/tunedustry/editor/view/Controls.as(43): col: 32 Warning: return value for function 'setPositions' has no type declaration.
  def parse!
    @output.each_line do |l|
      matches = ERROR_LINE.match(l)
      if !matches.nil?
        @errors << MxmlcError.new(matches[1], matches[5], matches[7], matches[8], matches[9])
      elsif !@errors.empty?
        @errors.last.content << l
      end
    end
  end
  
end