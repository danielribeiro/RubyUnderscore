$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'ruby_underscore'


class Enhanced
  include RubyUnderscore::Base
  def self.aPublicClassMethod
    [__method__].map _.to_s.concat('Enhanced')
  end
  
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

  it "should enhance class methods" do
    Enhanced.aPublicClassMethod.should == ["aPublicClassMethodEnhanced"]
  end

  it "the original method_added of the class must call super" do
    cl = Class.new do
      @@original_method_added_invoked = false
      def self.method_added(method_name)
        super
        @@original_method_added_invoked = true
      end
      include RubyUnderscore::Base

      def dummy
        'dum'
      end

      def self.original_method_added_invoked
        @@original_method_added_invoked
      end
    end
    cl.original_method_added_invoked.should be_true
  end


  it "will work even if the class defines singleton_method_added, but invokes super" do
    cl = Class.new do
      @@original_singleton_method_added_invoked = false
      def self.singleton_method_added(method_name)
        super
        @@original_singleton_method_added_invoked = true
      end
      include RubyUnderscore::Base

      def self.dummy
        [__method__].map _.to_s.concat('Enhanced')
      end

      def self.original_singleton_method_added_invoked
        @@original_singleton_method_added_invoked
      end
    end
    cl.original_singleton_method_added_invoked.should be_true
    cl.dummy.should == ["dummyEnhanced"]
  end
  
end

