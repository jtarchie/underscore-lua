*NOTE*: This is a 1-to-1 port of the orignal [Underscore](http://underscorejs.org/) for Javscript. Lua does not have the same concept of run-time loop, so anything functionality that relied on setTimeout has been removed.

# Introduction

[underscore-lua](https://github.com/jtarchie/underscore-lua) is a utility-belt library for Lua that provides a lot of the functional programming support that you would expect in or Ruby's Enumerable.

The project is hosted on [GitHub](https://github.com/jtarchie/underscore-lua). You can report bugs and discuss features on the [issues page](https://github.com/jtarchie/underscore-lua/issues), or send tweets to @jtarchie.

# Tests

The tests are written using [busted](http://olivinelabs.com/busted/). Run `busted` from the root of the source tree to run all the tests.

# Table of Contents

* [Collection](#collection-functions-arrays-or-objects)
* [Arrays](#arrays)
* [Objects](#objects)
* [String](#string)
* [Functions](#functions)
* [Utility](#utility)
* [Chaining](#chaining)
* [Changelog](#changelog)

# Collection functions (Arrays or Objects)

## each

`_.each(list, iterator)`
    
Iterates over a list of elements, yielding each in turn to an iterator function. Each invocation of iterator is called with three arguments: (element, index, list). If list is a Lua object, iterator's arguments will be (value, key, list).

```lua
_.each({1, 2, 3}, print)
=> print each number in turn...
_.each({one=1, two=2, three=3}, function(num, key) print(num) end)
=> print each number in turn...
```

## map

`_.map(list, iterator)` Alias: collect

Produces a new array of values by mapping each value in list through a transformation function (iterator). If list is a Lua object, iterator's arguments will be (value, key, list).

```lua
_.map({1, 2, 3}, function(num) return num * 3 end)
=> {3, 6, 9}
_.map({one=1, two=2, three=3}, function(num, key) return num * 3 end)
=> {3, 6, 9}
```

## reduce

`_.reduce(list, iterator, memo)` Aliases: inject, foldl 

Also known as inject and foldl, reduce boils down a list of values into a single value. Memo is the initial state of the reduction, and each successive step of it should be returned by iterator. The iterator is passed four arguments: the memo, then the value and index (or key) of the iteration, and finally a reference to the entire list.

```lua
local sum = _.reduce({1, 2, 3}, function(memo, num) return memo + num end, 0)
=> 6
```

## reduceRight

`_.reduceRight(list, iterator, memo)` Alias: foldr 

The right-associative version of reduce. Foldr is not as useful in Lua as it would be in a language with lazy evaluation.

```lua
local list = {{0, 1}, {2, 3}, {4, 5}}
local flat = _.reduceRight(list, function(a, b) return _.concat(a, b) end, {})
=> {4, 5, 2, 3, 0, 1}
```

## find

`_.find(list, iterator)` Alias: detect

Looks through each value in the list, returning the first one that passes a truth test (iterator). The function returns as soon as it finds an acceptable element, and doesn't traverse the entire list.

```lua
local even = _.find({1, 2, 3, 4, 5, 6}, function(num) return num % 2 == 0 end)
=> 2
```

## filter

`_.filter(list, iterator)` Alias: select

Looks through each value in the list, returning an array of all the values that pass a truth test (iterator). Delegates to the native filter method, if it exists.

```lua
local evens = _.filter({1, 2, 3, 4, 5, 6}, function(num) return num % 2 == 0 end)
=> {2, 4, 6}
```

## where

`_.where(list, properties)`

Looks through each value in the list, returning an array of all the values that contain all of the key-value pairs listed in properties.

```lua
_.where(listOfPlays, {author="Shakespeare", year=1611})
=> {{title="Cymbeline", author="Shakespeare", year=1611},
    {title="The Tempest", author="Shakespeare", year=1611}}
```

## reject

`_.reject(list, iterator)`

Returns the values in list without the elements that the truth test (iterator) passes. The opposite of filter.

```lua
local odds = _.reject({1, 2, 3, 4, 5, 6}, function(num) return num % 2 == 0 end)
=> {1, 3, 5}
```

## all

`_.all(list, iterator)` Alias: every 

Returns true if all of the values in the list pass the iterator truth test.

```lua
_.all({true, 1, nil, 'yes'}, _.identity)
=> false
```

## contains

`_.contains(list, value)` Alias: include 

Returns true if the value is present in the list. Uses indexOf internally, if list is an Array.

```lua
_.contains({1, 2, 3}, 3)
=> true
```

## invoke

`_.invoke(list, methodName, [*arguments])` 

Calls the method named by methodName on each value in the list. Any extra arguments passed to invoke will be forwarded on to the method invocation.

```lua
local dog = {says=function() return "woof" end}
local cat = {says=function() return "meow" end}
local cow = {says=function() return "moo" end}
_.invoke({dog, cat, cow}, 'says')
=> {'woof', 'meow', 'moo'}
```

## pluck

`_.pluck(list, propertyName)`

A convenient version of what is perhaps the most common use-case for map: extracting a list of property values.

```lua
local stooges = {{name='moe', age=40}, {name='larry', age=50}, {name='curly', age=60}}
_.pluck(stooges, 'name')
=> {"moe", "larry", "curly"}
```

## max

`_.max(list, [iterator])`

Returns the maximum value in list. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.

```lua
local stooges = {{name='moe', age=40}, {name='larry', age=50}, {name='curly', age=60}}
_.max(stooges, function(stooge) return stooge.age end)
=> {name='curly', age=60}
```

## min

`_.min(list, [iterator])`

Returns the minimum value in list. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.

```lua
local numbers = {10, 5, 100, 2, 1000}
_.min(numbers)
=> 2
```

## sortBy

`_.sortBy(list, iterator)`

Returns a sorted copy of list, ranked in ascending order by the results of running each value through iterator. Iterator may also be the string name of the property to sort by (eg. length).

```lua
_.sortBy({1, 2, 3, 4, 5, 6}, function(num) return math.sin(num) end)
=> {5, 4, 6, 3, 1, 2}
```

## groupBy

`_.groupBy(list, iterator)`

Splits a collection into sets, grouped by the result of running each value through iterator. If iterator is a string instead of a function, groups by the property named by iterator on each of the values.

```lua
_.groupBy({1.3, 2.1, 2.4}, function(num) return math.floor(num) end)
=> {1={1.3}, 2={2.1, 2.4}
```

## countBy

`_.countBy(list, iterator)`

Sorts a list into groups and returns a count for the number of objects in each group. Similar to groupBy, but instead of returning a list of values, returns a count for the number of values in that group.

```lua
_.countBy({1, 2, 3, 4, 5}, function(num) 
  if num % 2 == 0 then
    return 'even'
  else
    return 'odd'
  end
end)
=> {odd=3, even=2}
```

## shuffle

`_.shuffle(list)`

Returns a shuffled copy of the list, using a version of the Fisher-Yates shuffle.

```lua
_.shuffle({1, 2, 3, 4, 5, 6})
=> {4, 1, 6, 3, 5, 2}
```


## toArray

`_.toArray(list)`

Converts the list (anything that can be iterated over), into a real Array. Useful for transmuting the arguments object.

```lua
_.toArray(1, 2, 3, 4)
=> {2, 3, 4}
```


## size

`_.size(list)`

Return the number of values in the list.

```lua
_.size({one=1, two=2, three=3})
=> 3
```

#Arrays

## first

`_.first(array, [n])` Alias: head, take 

Returns the first element of an array. Passing n will return the first n elements of the array.

```lua
_.first({5, 4, 3, 2, 1})
=> 5
```

## initial

`_.initial(array, [n])`

Returns everything but the last entry of the array. Especially useful on variable arguments object. Pass n to exclude the last n elements from the result.

```lua
_.initial({5, 4, 3, 2, 1})
=> {5, 4, 3, 2}
```

## last
  
`_.last(array, [n])`

Returns the last element of an array. Passing n will return the last n elements of the array.

```lua
_.last({5, 4, 3, 2, 1})
=> 1
```

## rest

`_.rest(array, [index])` Alias: tail, drop 

Returns the rest of the elements in an array. Pass an index to return the values of the array from that index onward.

```lua
_.rest({5, 4, 3, 2, 1})
=> {4, 3, 2, 1}
```

## compact
  
`_.compact(array)`

Returns a copy of the array with all falsy values removed. In Lua, false is the only falsy value.

```lua
_.compact({0, 1, false, 2, '', 3})
=> {0, 1, 2, '', 3}
```

## flatten
  
`_.flatten(array, [shallow])`

Flattens a nested array (the nesting can be to any depth). If you pass shallow, the array will only be flattened a single level.

```lua
_.flatten({1, {2}, {3, {{4}}}})
=> {1, 2, 3, 4}
_.flatten({1, {2}, {3, {{4}}}}, true)
=> {1, 2, 3, {{4}}}
```

## without

`_.without(array, [*values])`

Returns a copy of the array with all instances of the values removed.

```lua
_.without({1, 2, 1, 0, 3, 1, 4}, 0, 1)
=> {2, 3, 4}
```

## union
  
`_.union(*arrays)`

Computes the union of the passed-in arrays: the list of unique items, in order, that are present in one or more of the arrays.

```lua
_.union({1, 2, 3}, {101, 2, 1, 10}, {2, 1})
=> {1, 2, 3, 101, 10}
```

## intersection

`_.intersection(*arrays)`

Computes the list of values that are the intersection of all the arrays. Each value in the result is present in each of the arrays.

```lua
_.intersection({1, 2, 3}, {101, 2, 1, 10}, {2, 1})
=> {1, 2}
```

## difference

`_.difference(array, *others)`

Similar to without, but returns the values from array that are not present in the other arrays.

```lua
_.difference({1, 2, 3, 4, 5}, {5, 2, 10})
=> {1, 3, 4}
```

## uniq

`_.uniq(array, [isSorted], [iterator])` Alias: unique

Produces a duplicate-free version of the array, using === to test object equality. If you know in advance that the array is sorted, passing true for isSorted will run a much faster algorithm. If you want to compute unique items based on a transformation, pass an iterator function.

```lua
_.uniq({1, 2, 1, 3, 1, 4})
=> {1, 2, 3, 4}
```

## zip

`_.zip(*arrays)`

Merges together the values of each of the arrays with the values at the corresponding position. Useful when you have separate data sources that are coordinated through matching array indexes. If you're working with a matrix of nested arrays, zip.apply can transpose the matrix in a similar fashion.

```lua
_.zip({'moe', 'larry', 'curly'}, {30, 40, 50}, {true, false, false})
=> {{"moe", 30, true}, {"larry", 40, false}, {"curly", 50, false}}
```

## object

`_.object(list, [values])`

Converts arrays into objects. Pass either a single list of (key, value) pairs, or a list of keys, and a list of values.

```lua
_.object({'moe', 'larry', 'curly'}, {30, 40, 50})
=> {moe=30, larry=40, curly=50}
_.object({{'moe', 30}, {'larry', 40}, {'curly', 50}})
=> {moe=30, larry=40, curly=50}
```

## indexOf

`_.indexOf(array, value, [isSorted])`

Returns the index at which value can be found in the array, or 0 if value is not present in the array. Uses the native indexOf function unless it's missing. If you're working with a large array, and you know that the array is already sorted, pass true for isSorted to use a faster binary search ... or, pass a number as the third argument in order to look for the first matching value in the array after the given index.

```lua
_.indexOf({1, 2, 3}, 2)
=> 1
```

## lastIndexOf

`_.lastIndexOf(array, value, [fromIndex])`

Returns the index of the last occurrence of value in the array, or 0 if value is not present. Uses the native lastIndexOf function if possible. Pass fromIndex to start your search at a given index.

```lua
_.lastIndexOf({1, 2, 3, 1, 2, 3}, 2)
=> 4
```

## range

`_.range([start], stop, [step])`

A function to create flexibly-numbered lists of integers, handy for each and map loops. start, if omitted, defaults to 0; step defaults to 1. Returns a list of integers from start to stop, incremented (or decremented) by step, exclusive.

```lua
_.range(10)
=> {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
_.range(1, 11)
=> {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
_.range(0, 30, 5)
=> {0, 5, 10, 15, 20, 25}
_.range(0, -10, -1)
=> {0, -1, -2, -3, -4, -5, -6, -7, -8, -9}
_.range(0)
=> {} 
```

## pop

`_.pop(array)`

Removes the last element from an array and returns that value.

```lua
_.pop({1,2,3,4})
=> 4
```

## push

`_.push(array, [elements])`

Adds the list of elements on to the end of an array.

```lua
local array = {1,2,3}
_.push(array, 4,5,6)
=> {1,2,3,4,5,6}
=> array == {1,2,3,4,5,6}
```

## shift

`_.shift(array)`

Removes the last element from an array and returns that value.

```lua
_.shift({1,2,3,4})
=> 1
```

## unshift

`_.unshift(array, [elements])`

Adds the list of elements on to the end of an array.


```lua
local array = {1,2,3}
_.unshift(array, 4,5,6)
=> {4,5,6,1,2,3}
=> array == {4,5,6,1,2,3}
```

## slice

`_.slice(array, begin, [end])`

Returns a portion of the array that starts from begin and returning all the elemtns to the end of the array. If end is provided then it provideds the elements to that position.

```lua
_.slice({1,2,3,4,5,6,7,8}, 4)
=> {4,5,6,7,8}
_.slice({1,2,3,4,5,6,7,8}, 4, 6)
=> {4,5,6}
```

## sort

`_.sort(array, [compareFunction])`

Sorts the elements in the array based on the `tostring` value of the element. For numerical values, this puts "80" before "9" in their lexical form.

With the compareFunction, the elements are sorted based on the returned value. This relies on Lua's underlying `table.sort` so the comparison relies the value being compared as less than or grater than.

```lua
_.sort({"how","are","you","today"})
=> {"are","how","today","you"}
_.sort({1,5,10,90})
=> {1,10,5,90}
```

## concat

`_.concat(value1, value2, ..., arrayn)`

Creates a new array by concatenating the values passed in. It does not alter the original versions of the values passed in.

```lua
_.concat(1,2,3,4,5,6)
=> {1,2,3,4,5,6}
_.concat({1,2,3},{4,5,6})
=> {1,2,3,4,5,6}
```

## join

`_.join(array, [separator])`

Joins the elements of an array into a string. By default the separator is a blank string. If a separator is passed then it will be used as the string that separates the elements in the string.

```lua
_.join({1,2,3,4,5})
=> "12345"
_.join({"Hello", "world"}, ", ")
=> "Hello, world"
```

## splice

`_.splice(array, index, [howMany, element1, element2, .., elementN])`

Changes the content of an array, adding new elements while removing old elements. Will start changing elements starting at index and remove howMany elements from that position. Elements can be provided to replace the elements that are being removed.

If hasMany is not specified it remove all elements to the end of the array.

```lua
local kids = {'bart', 'marsha', 'maggie'}
_.splice(kids, 2, 1, 'lisa')
=> {'marsha'}
array == {'bart', 'lisa', 'maggie'}
```

#Functions

## memoize

`_.memoize(function, [hashFunction])`

Memoizes a given function by caching the computed result. Useful for speeding up slow-running computations. If passed an optional hashFunction, it will be used to compute the hash key for storing the result, based on the arguments to the original function. The default hashFunction just uses the first argument to the memoized function as the key.

```lua
local fibonacci = _.memoize(function(n)
  if n < 2 then
    return n
  else 
    return fibonacci(n - 1) + fibonacci(n - 2)
  end
end)
```

## once

`_.once(function)`

Creates a version of the function that can only be called one time. Repeated calls to the modified function will have no effect, returning the value from the original call. Useful for initialization functions, instead of having to set a boolean flag and then check it later.

```lua
local initialize = _.once(createApplication)
initialize()
initialize()
```

## after

`_.after(count, function)`

Creates a version of the function that will only be run after first being called count times. Useful for grouping asynchronous responses, where you want to be sure that all the async calls have finished, before proceeding.

```lua
local renderNotes = _.after(_.size(notes), render)
_.each(notes, function(note)
  note.asyncSave({success: renderNotes})
end)
```

## bind

`_.bind(function, table, [arguments])`

Bind a function to a table, meaning that whenever the function is called, the value of self will be the table. Optionally, bind arguments to the function to pre-fill them, also known as partial application.

```lua
local greet = function(self, greeting) return greeting .. ': ' .. self.name end

func = _.bind(greet, {name = 'moe'})
func('hi')
=> 'hi: moe'

func = _.bind(greet, {name = 'moe'}, 'hey')
func()
=> 'hey: moe'
```


## wrap

`_.wrap(function, wrapper)`

Wraps the first function inside of the wrapper function, passing it as the first argument. This allows the wrapper to execute code before and after the function runs, adjust the arguments, and execute it conditionally.

```lua
local hello = function(name) return "hello: " + name end
hello = _.wrap(hello, function(func)
  return "before, " + func("moe") + ", after"
end)
hello()
=> 'before, hello: moe, after'
```

## compose
  
`_.compose(*functions)`

Returns the composition of a list of functions, where each function consumes the return value of the function that follows. In math terms, composing the functions f(), g(), and h() produces f(g(h())).

```lua
local greet    = function(name) return "hi: " + name end
local exclaim  = function(statement) return statement + "!" end
local welcome = _.compose(exclaim, greet)
welcome('moe')
=> 'hi: moe!'
```

#Objects

## keys

`_.keys(object)`

Retrieve all the names of the object's properties. The order of the keys is not guaranteed to be consistent.

```lua
_.keys({one=1, two=2, three=3})
=> {"one", "two", "three"}
```
## values

`_.values(object)`

Return all of the values of the object's properties. The order of the values is not guaranteed to be consistent.

```lua
_.values({one=1, two=2, three=3})
=> {1, 2, 3}
```

## pairs

`_.pairs(object)`

Convert an object into a list of [key, value] pairs.

```lua
_.pairs({one=1, two=2, three=3})
=> [["one", 1], ["two", 2], ["three", 3]]
```

## invert

`_.invert(object)`

Returns a copy of the object where the keys have become the values and the values the keys. For this to work, all of your object's values should be unique and string serializable.

```lua
_.invert({Moe="Moses", Larry="Louis", Curly="Jerome"})
=> {Moses="Moe", Louis="Larry", Jerome="Curly"}
```

## functions

`_.functions(object)` Alias: methods

Returns a sorted list of the names of every method in an object — that is to say, the name of every function property of the object.

```lua
_.functions(_)
=> {"all", "any", "bind", "bindAll", "clone", "compact", "compose" ... }
```

## extend

`_.extend(destination, *sources)`

Copy all of the properties in the source objects over to the destination object, and return the destination object. It's in-order, so the last source will override properties of the same name in previous arguments.

```lua
_.extend({name='moe'}, {age=50})
=> {name='moe', age=50}
```

## pick

`_.pick(object, *keys)`

Return a copy of the object, filtered to only have values for the whitelisted keys (or array of valid keys).

```lua
_.pick({name='moe', age=50, userid='moe1'}, 'name', 'age')
=> {name='moe', age=50}
```

## omit

`_.omit(object, *keys)`

Return a copy of the object, filtered to omit the blacklisted keys (or array of keys).

```lua
_.omit({name='moe', age=50, userid='moe1'}, 'userid')
=> {name='moe', age=50}
```

## defaults

`_.defaults(object, *defaults)`

Fill in null and undefined properties in object with values from the defaults objects, and return the object. As soon as the property is filled, further defaults will have no effect.

```lua
local iceCream = {flavor="chocolate"}
_.defaults(iceCream, {flavor="vanilla", sprinkles="lots"})
=> {flavor="chocolate", sprinkles="lots"}
```

## clone

`_.clone(object)`

Create a shallow-copied clone of the object. Any nested objects or arrays will be copied by reference, not duplicated.

```lua
_.clone({name='moe'})
=> {name='moe'}
```

## tap

`_.tap(object, interceptor)`

Invokes interceptor with the object, and then returns object. The primary purpose of this method is to "tap into" a method chain, in order to perform operations on intermediate results within the chain.

```lua
_.chain([1,2,3,200])
  :filter(function(num) return num % 2 == 0 end)
  :tap(print)
  --  {2, 200}
  :map(function(num) return num * num end)
  :value()
=> {4, 40000}
```

## has

`_.has(object, key)`

Does the object contain the given key? Identical to object.hasOwnProperty(key), but uses a safe reference to the hasOwnProperty function, in case it's been overridden accidentally.

```lua
_.has({a=1, b=2, c=3}, "b")
=> true
```

## isEqual

Not yet implemented

## isEmpty

`_.isEmpty(object)`

Returns true if object contains no values.

```lua
_.isEmpty({1, 2, 3})
=> false
_.isEmpty({})
=> true
```

## isArray

`_.isArray(object)`

Returns true if object is an Array.

```lua
_.isArray({1,2,3})
=> true
```

## isObject

`_.isObject(value)`

Returns true if value is an Object. Note that JavaScript arrays and functions are objects, while (normal) strings and numbers are not.

```lua
_.isObject({})
=> true
_.isObject(1)
=> false
```

## isFunction

`_.isFunction(object)`

Returns true if object is a Function.

```lua
_.isFunction(print)
=> true
```

## isString

`_.isString(object)`

Returns true if object is a String.

```lua
_.isString("moe")
=> true
```

## isNumber

`_.isNumber(object)`

Returns true if object is a Number (including NaN).

```lua
_.isNumber(8.4 * 5)
=> true
```

## isFinite

`_.isFinite(object)`

Returns true if object is a finite Number.

```lua
_.isFinite(-101)
=> true
_.isFinite(math.huge)
=> false
```

## isBoolean

`_.isBoolean(object)`

Returns true if object is either true or false.

```lua
_.isBoolean(nil)
=> false
```

## isNaN

`_.isNaN(object)`

Returns true if object is NaN.

```lua
_.isNaN(0/0)
=> true
_.isNaN(1)
=> false
```

## isNil

`_.isNil(object)`

Returns true if the value of object is nil.

```lua
_.isNil(nil)
=> true
_.isNil(1)
=> false
```

#Utility

## identity

`_.identity(value)`

Returns the same value that is used as the argument. In math: f(x) = x

This function looks useless, but is used throughout Underscore as a default iterator.

```lua
local moe = {name='moe'}
moe == _.identity(moe);
=> true
```

## times

`_.times(n, iterator)`

Invokes the given iterator function n times. Each invocation of iterator is called with an index argument.

```lua
_(3).times(function(n) genie.grantWishNumber(n) end)
```

## random

`_.random(min, max)`

Returns a random integer between min and max, inclusive. If you only pass one argument, it will return a number between 0 and that number.

```lua
_.random(0, 100)
=> 42
```

## mixin

`_.mixin(object)`

Allows you to extend Underscore with your own utility functions. Pass a hash of {name: function} definitions to have your functions added to the Underscore object, as well as the OOP wrapper.

```lua
_.mixin({
  capitalize=function(s)
    return s:substr(1,1):upper() .. s:substr(2):lower()
  end
})
_("fabio").capitalize();
=> "Fabio"
```

## uniqueId

`_.uniqueId([prefix])`

Generate a globally-unique id for client-side models or DOM elements that need one. If prefix is passed, the id will be appended to it. Without prefix, returns an integer.

```lua
_.uniqueId('contact_')
=> 'contact_104'
```

## escape

`_.escape(string)`

Escapes a string for insertion into HTML, replacing &, <, >, ", ', and / characters.

```lua
_.escape('Curly, Larry & Moe')
=> "Curly, Larry &amp; Moe"
```

## unescape

`_.unescape(string)`

Un-escapes a string from HTML to the proper characters  &, <, >, ", ', and /.

```lua
_.unescape('Curly, Larry &amp Moe')
=> "Curly, Larry & Moe"
```

## result

`_.result(object, property)`

If the value of the named property is a function then invoke it; otherwise, return it.

```lua
var object = {cheese='crumpets', stuff=function() return 'nonsense' end}
_.result(object, 'cheese')
=> "crumpets"
_.result(object, 'stuff')
=> "nonsense"
```

# String

## split

`_.split(value, [separator])`

Splits a string into an array of strings by separating the string into substrings. If there is no separator is passed, the substring are individual characters.

With a separator, the substring is string up to the separator position. The separator can be a [string pattern](http://www.lua.org/manual/5.2/manual.html#6.4.1).

```lua
_.split("John Smith")
=> {"J","o","h","n"," ","S","m","i","t","h"}
_.split("John Smith", "%s+")
=> {"John", "Smith"}
```

#Chaining

You can use Underscore in either an object-oriented or a functional style, depending on your preference. The following two lines of code are identical ways to double a list of numbers.

```lua
_.map([1, 2, 3], function(n) return n * 2 end)
_([1, 2, 3]).map(function(n) return n * 2 end)
```

Calling chain will cause all future method calls to return wrapped objects. When you've finished the computation, use value to retrieve the final value. Here's an example of chaining together a map/flatten/reduce, in order to get the word count of every word in a song.

```lua
local lyrics = {
  {line=1, words="I'm a lumberjack and I'm okay"},
  {line=2, words="I sleep all night and I work all day"},
  {line=3, words="He's a lumberjack and he's okay"},
  {line=4, words="He sleeps all night and he works all day"}
}

_.chain(lyrics)
  :map(function(line) return _.split(line.words, ' ') end)
  :flatten()
  :reduce(function(counts, word)
    counts[word] = counts[word] or 0
    counts[word] = counts[word] + 1
    return counts
  end, {})
  :value()

=> {lumberjack=2, all=4, night=2 ... }
```

## chain

`_.chain(obj)`

Returns a wrapped object. Calling methods on this object will continue to return wrapped objects until value is used.

```lua
local stooges = {{name='curly', age=25}, {name='moe', age=21}, {name='larry', age=23}}
local youngest = _.chain(stooges)
  :sortBy(function(stooge) return stooge.age end)
  :map(function(stooge) return stooge.name .. ' is ' .. stooge.age end)
  :first()
  :value()
=> "moe is 21"
```

## value

`_(obj).value()`

Extracts the value of a wrapped object.

```lua
_({1, 2, 3}).value();
=> {1, 2, 3}
```


#Changelog
