require File.join(File.dirname(__FILE__), 'mxmlc_error')


# Formats the mxmlc to errors
class MxmlcOutputReader
  attr_reader :errors

  def initialize(output)
    @output = output
    @errors = []
    parse!
  end
  
  
  # example: /Users/japetheape/Projects/tunedustry/editor/src/com/tunedustry/editor/view/Controls.as(43): col: 32 Warning: return value for function 'setPositions' has no type declaration.
  def parse!
    @output.each_line do |l|
      matches = /^((\/([\w\.]+))+)\((\d+)\): col: (\d+) (\w+): (.+)$/.match(l)
      if !matches.nil?
        @errors << MxmlcError.new(matches[1], matches[4], matches[5], matches[6], matches[7])
      elsif !@errors.empty?
        @errors.last.content << l
      end
    end
  end
  
end