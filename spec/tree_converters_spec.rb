$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'tree_converters'

class Checks
  def doesntNeedEnhancing
    (1..20).map do |i|
      i + 1
    end
  end

  def stillNoEnhancing
    _(9)
  end

  def needsEnhacing
    [0].map _
  end

  def alsoNeedsEnhacing
    [0].map _.to_s
  end
end

class Input
  def simple
    [0].map _
  end
end

class Expected
  def simple
    [0].map {|x| x}
  end
end

describe 'TreeConverters' do
  attr_reader :un

  before(:each) do
    @un = UnderscoreEnhancer.new
  end

  def assert_same_after_enhancing(method)
    un.enhance Input, method
    un.sexpOf(Input, method).should == un.sexpOf(Expected, method)
    Input.new.send(method).should == Expected.new.send(method)
  end

  it "detects correctly what needs and what doesn't need enhancing" do
    un.needsEnhancing(Checks, :doesntNeedEnhancing).should be_false
    un.needsEnhancing(Checks, :stillNoEnhancing).should be_false
    un.needsEnhancing(Checks, :needsEnhacing).should be_true
    un.needsEnhancing(Checks, :alsoNeedsEnhacing).should be_true
  end

  it "should enhance a simple identity" do
    assert_same_after_enhancing :simple
  end
end

