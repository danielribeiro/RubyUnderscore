#!/usr/bin/env ruby
require 'ruby_underscore'

class MethodFinder
  include RubyUnderscore::Base

  def find_interrogation_methods
    [String, Array, Class].map(_.public_instance_methods.grep /d\?$/).flatten.sort.uniq
  end
end
p MethodFinder.new.find_interrogation_methods