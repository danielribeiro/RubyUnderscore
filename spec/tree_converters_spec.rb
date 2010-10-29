$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'tree_converters'
require 'pp'

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

  def methodCall
    [0].map _.to_s
  end

  def longComplexMethodChain
    [0].map _.to_i.to_s.center(40, '-').to_s
  end

  def nested
    ["1"].concat([0].map _.to_s)
  end
end

class Expected
  def simple
    [0].map { |x| x }
  end

  def methodCall
    [0].map { |x| x.to_s }
  end

  def longComplexMethodChain
    [0].map { |x| x.to_i.to_s.center(40, '-').to_s }
  end

  def nested
    ["1"].concat([0].map { |x| x.to_s } )
  end
end

describe 'TreeConverters' do
  attr_reader :un

  before(:each) do
    @un = UnderscoreEnhancer.new
  end

  def assert_same_after_enhancing(method)
    un.enhance Input, method
    input = un.sexpOf Input, method
    output = un.sexpOf Expected, method
#    pp input
#    pp output
    input.should == output
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

  it "should enhance a simple method call" do
    assert_same_after_enhancing :methodCall
  end

  it "should enhance a complex method chain" do
    assert_same_after_enhancing :longComplexMethodChain
  end

  it "should enhance a complex nested chain" do
    assert_same_after_enhancing :nested
  end
end

