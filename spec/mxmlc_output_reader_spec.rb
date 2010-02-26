require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MxmlcOutputReader" do
  before(:each) do
    mxmlc_output_file = File.join(File.dirname(__FILE__), 'fixtures', 'mxmlc_output.txt')
    @output = ''
    File.open(mxmlc_output_file).each_line { |l| @output << l }
    @mxmlc_output_reader = MxmlcOutputReader.new(@output)
  end
    
    
  it "should contain errors" do
    @mxmlc_output_reader.errors.length.should be 51
  end
end
