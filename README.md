*NOTE*: This is a 1-to-1 port of the orignal [Underscore](http://underscorejs.org/) for Javscript. Lua does not have the same concept of run-time loop, so anything functionality that relied on setTimeout has been removed.

# Introduction

[underscore-lua](https://github.com/jtarchie/underscore-lua) is a utility-belt library for Lua that provides a lot of the functional programming support that you would expect in or Ruby's Enumerable.

The project is hosted on [GitHub](https://github.com/jtarchie/underscore-lua). You can report bugs and discuss features on the [issues page](https://github.com/jtarchie/underscore-lua/issues), or send tweets to @jtarchie.

#Collection functions (Arrays or Objects)

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
=> [2, 3, 4]
```


## size

`_.size(list)`

Return the number of values in the list.

```lua
_.size({one=1, two=2, three=3})
=> 3
```

#Arrays


#Functions


#Objects


#Utility


#Chaining


#Changelog
