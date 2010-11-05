RubyUnderscore
==============

[Closures](http://metaphysicaldeveloper.wordpress.com/2009/05/02/closures-collections-and-some-functional-programming/)
are very useful tools, and ruby
[Enumerable](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html) mixin makes them even
more useful. 

However, as you decompose more and more your iterations into a sequence of
[maps](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html#M001146),
[selects](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html#M001143),
[rejects](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html#M001144),
[group_bys](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html#M001150) and
[reduces](http://ruby-doc.org/core-1.8.7/classes/Enumerable.html#M001148), more commonly
you see simple blocks such as:

    collection.map { |x| x.invoke }
    dates.select { |d| d.greater_than(old_date) }
    classes.reject { |c| c.subclasses.include?(Array) }

RubyUnderscore modify classes so that you can also use a short notation for simple closures. With such, the above examples can be written as:

    collection.map _.invoke
    dates.select _.greater_than old_date
    classes.reject _.subclasses.include? Array

Just replace the iterating argument with the underscore symbol (*_*), and ditch the
parenthesis. [More info](http://metaphysicaldeveloper.wordpress.com/2010/10/31/rubyunderscore-a-bit-of-arc-and-scala-in-ruby/)

Quick Example
----



Meta
----

Created by Daniel Ribeiro

Released under the MIT License: http://www.opensource.org/licenses/mit-license.php

http://github.com/danielribeiro/RubyUnderscore
