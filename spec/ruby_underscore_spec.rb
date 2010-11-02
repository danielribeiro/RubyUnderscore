$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'ruby_underscore'

class Enhanced
  include RubyUnderscore::Base
  def aPublic
    [__method__].map _.to_s.concat('Enhanced')
  end

  def aPrivate
    [__method__].map _.to_s.concat('Enhanced')
  end
end

describe RubyUnderscore do
  it "should enhance all methods of a class that includes RubyUnderscore::Base" do
    Enhanced.new.aPublic.should == ["aPublicEnhanced"]
  end

  it "should enhance private methods as well" do
    Enhanced.new.aPrivate.should == ["aPrivateEnhanced"]
  end
  
end

