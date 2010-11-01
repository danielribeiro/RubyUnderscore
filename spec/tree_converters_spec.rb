$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'tree_converters'
require 'pp'

# Making it simple to test.
class VcallEnhancer
  def variableName
    :x
  end
end


class Array
  def mapProc(proc)
    map &proc
  end
end

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

module OutputHelper
  def map(&block)
    [0].map &block
  end

  def idblock(&block)
    block
  end

  def identity_of(arg)
    arg
  end
end

class Input
  include OutputHelper
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

  def fcall
    map _.to_s
  end

  def multiple_fcall
    identity_of map _.to_s
  end

  def fcall_call_mix
    identity_of [0].map _.to_s
  end

  def call_fcall_mix
    [0].mapProc idblock _.to_s
  end

end

class Expected
  include OutputHelper
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

  def fcall
    map { |x| x.to_s }
  end

  def multiple_fcall
    identity_of map { |x| x.to_s }
  end

  def fcall_call_mix
    identity_of [0].map { |x| x.to_s }
  end

  def call_fcall_mix
    [0].mapProc idblock { |x| x.to_s }
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

  [:simple, :methodCall, :longComplexMethodChain, :nested,
    :fcall, :multiple_fcall, :fcall_call_mix, :call_fcall_mix].each do |m|
    it m.to_s do
      assert_same_after_enhancing m
    end
  end
end

