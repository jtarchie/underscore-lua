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

  Produces a new array of values by mapping each value in list through a transformation function (iterator). If list is a JavaScript object, iterator's arguments will be (value, key, list).

```lua
_.map({1, 2, 3}, function(num) return num * 3 end)
=> {3, 6, 9}
_.map({one=1, two=2, three=3}, function(num, key) return num * 3 end)
=> {3, 6, 9}
```

#Arrays


#Functions


#Objects


#Utility


#Chaining


#Changelog
