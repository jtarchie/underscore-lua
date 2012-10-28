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

#Functions


#Objects


#Utility


#Chaining


#Changelog
