require 'tree_converters'

module RubyUnderscore
  module Base
    module ClassMethods
      def method_added(method_name)
        UnderscoreEnhancer.new.enhance(self, method_name)
      end
    end

    module InstanceMethods

    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
