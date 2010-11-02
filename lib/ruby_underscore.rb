require 'tree_converters'

module RubyUnderscore
  module Base
    module ClassMethods
      def method_added(method_name)
        super
        UnderscoreEnhancer.new.enhance self, method_name
      end

      def singleton_method_added(method_name)
        super
        metaclass = class << self; self; end
        UnderscoreEnhancer.new.enhance metaclass, method_name
      end
    end
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
