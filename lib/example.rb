#!/usr/bin/env ruby
require 'ruby_underscore'

class MethodFinder
  include RubyUnderscore::Base

  def find_interrogation_methods
    [String, Array, Class].map(_.public_instance_methods.grep /\?$/).inject :+
  end
end
p MethodFinder.new.find_interrogation_methods.sort.uniq