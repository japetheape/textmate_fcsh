require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MxmlcOutputReader" do
  before(:each) do
    
  end
    
    
  it "should contain errors" do
    mxmlc_output_file = File.join(File.dirname(__FILE__), 'fixtures', 'mxmlc_output.txt')
    @output = ''
    File.open(mxmlc_output_file).each_line { |l| @output << l }
    @mxmlc_output_reader = MxmlcOutputReader.new(@output)
    @mxmlc_output_reader.errors.length.should be 52
  end
  
  
  it "should catch an error" do
    out = "/Users/japetheape/Projects/tunedustry/editor/src/editor.mxml(19):  Error: Incorrect number of arguments.  Expected no more than 0."
    MxmlcOutputReader::ERROR_LINE.match(out).should_not be nil
  end
  
  
  it "should also process this line" do
    out = <<EOD
/Users/japetheape/Projects/tunedustry/editor/src/com/tunedustry/editor/view/MainView.mxml(45):  Error: Access of undefined property fControls.
  
    adsad
    
/Users/japetheape/Projects/tunedustry/editor/src/com/tunedustry/editor/controller/ProgressController.as(4): col: 49 Warning: Definition editor_core.com.tunedustry.general.model:SoundProject could not be found.

    	import editor_core.com.tunedustry.general.model.SoundProject;
EOD
    
    reader = MxmlcOutputReader.new(out)
    reader.errors.size.should be 2
    reader.errors.first.level.should be == "Error"
    reader.errors.last.level.should be == "Warning"
    
  end
end
