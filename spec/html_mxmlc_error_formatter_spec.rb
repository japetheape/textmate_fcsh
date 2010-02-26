require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HtmlMxmlcErrorFormatter" do
  before(:each) do
    @html_formatter = HtmlMxmlcErrorFormatter.new([MxmlcError.new('test.as', 1, 2, 'warning', 'Not initialized.')])
  end
  
  
  it "should have generated something" do
    @html_formatter.out.empty?.should_not be true
    #puts @html_formatter.out
  end
end
