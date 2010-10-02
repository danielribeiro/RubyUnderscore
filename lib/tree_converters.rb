#!/usr/bin/env ruby
require 'pp'

gem 'ParseTree', '=3.0.5'
require 'sexp_processor'
require 'ruby2ruby'
require 'unified_ruby'
require 'parse_tree'

class AbstractProcessor < SexpProcessor
  def initialize
    super
    @alternate = SexpProcessor.new
  end

  def proceed(exp)
    @alternate.process exp
  end

  def assert_empty(meth, exp, exp_orig)

  end
end

module EnhancerHelper
  def clone(array)
    a = []
    array.each do | x |
      if x.is_a? Array
        a << clone(x)
      elsif x.is_a? Symbol or x.is_a? Fixnum
        a << x
      else
        a << x.clone
      end
    end
    a
  end

  def needsEnhancing(clas, method)
    sexpNeedsEnhancing sexpOf clas, method
  end


  def sexpOf(clas, method)
    ParseTree.translate clas, method
  end

  def sexpNeedsEnhancing(sexp)
    parser = EnhancerDetector.new
    parser.process clone sexp
    return parser.needsEnhancing
  end

  class EnhancerDetector < AbstractProcessor
    attr_reader :needsEnhancing

    def initialize
      super
      @needsEnhancing = false
    end

    def process_vcall(sexp)
      if sexp[1] == :_
        @needsEnhancing = true
        return s
      end
      return s *sexp
    end
  end
end


class VcallReplacer < AbstractProcessor

end
class VcallEnhancer < AbstractProcessor
  include EnhancerHelper
  def process_call(sexp)
    call, target, method, args = sexp
    return s *sexp unless sexpNeedsEnhancing sexp
    ret = s(:iter, s(call, target, method), s(:dasgn_curr, :x), s(:dvar, :x))
    return ret
  end

end


class UnderscoreEnhancer
  include EnhancerHelper

  def enhance(clas, method)
    sexp = sexpOf clas, method
    return unless sexpNeedsEnhancing sexp
    result = VcallEnhancer.new.process sexp
    strToEval = Ruby2Ruby.new.process Unifier.new.process result
    clas.class_eval strToEval
  end
end