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
  # Deep Clone or arrays. Focused on arrays to be converted into sexp.
  def clone(array)
    a = []
    array.each do | x |
      a << if x.is_a? Array
        clone(x)
      elsif x.is_a? Symbol or x.is_a? Fixnum
        x
      else
        x.clone
      end
    end
    a
  end

  def chain(sexp, *processorClasses)
    processorClasses.inject(sexp) do |memo, clas|
      clas.new.process memo
    end
  end

  def needsEnhancing(clas, method)
    sexpNeedsEnhancing sexpOf clas, method
  end


  def sexpOf(clas, method)
    ParseTree.translate clas, method
  end

  def sexpNeedsEnhancing(sexp)
    return false if sexp.nil?
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
      return s *sexp unless sexp[1] == :_
      @needsEnhancing = true
      s()
    end
  end
end



class VcallEnhancer < AbstractProcessor

  include EnhancerHelper
  def processCallSexp(callSexp)
    call, target, method, args = callSexp
    return s call, process(target), method unless args
    s call, process(target), method, process(args)
  end



  def variableName
    :x
  end

  def process_vcall(sexp)
    return s *sexp unless sexp[1] == :_
    s(:dvar, variableName)
  end

  def process_call(sexp)
    call, target, method, args = sexp
    return processCallSexp sexp unless sexpNeedsEnhancing args
    processed = process args
    return s(:iter, s(call, process(target), method), s(:dasgn_curr, variableName),
      processed[1])
  end

end


class UnderscoreEnhancer
  include EnhancerHelper

  def enhance(clas, method)
    sexp = sexpOf clas, method
    return unless sexpNeedsEnhancing sexp
    clas.class_eval chain sexp, VcallEnhancer, Unifier, Ruby2Ruby
  end

end

# Next test case: it has to be the closest (f)call to vcall_. calls with args to the _vcall,
# are just ignored
#class A
#  def x
#    "str".invoke("t".invoke(_.name))
#  end
#end
#
#u = UnderscoreEnhancer.new
#pp u.sexpOf A, :x