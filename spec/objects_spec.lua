local _ = require("lib/underscore")

describe("#keys", function()
  it("can extract keys from an object", function()
    assert.truthy(_.keys({one=1,two=2}),{'one','two'})
    assert.truthy(_.keys({moe=10}),{'moe'})
  end)

  it("throws a type error", function()
    assert.has.error(function() _.keys(nil) end)
    assert.has.error(function() _.keys(1) end)
    assert.has.error(function() _.keys('a') end)
    assert.has.error(function() _.keys(true) end)
  end)
end)

describe("#values", function()
  it("can extract values from an object", function()
    assert.truthy(_.values({one=10,two=20}), {10,20})
    assert.truthy(_.values({moe=1,curly=20,joe="joe"}), {"joe",20,1})
  end)

  it("returns the original values of an array", function()
    local list = {1,2,3}
    assert.equal(_.values(list), list)
  end)
end)

describe("#pairs", function()
  it("can convert an object into pairs", function()
    assert.same(_.pairs({one=1,two=2}),{{'one',1},{'two',2}})
    assert.same(_.pairs({moe=10,joe=20}),{{'joe',20},{'moe',10}})
  end)
end)

describe("#invert", function()
  it("changes keys<->values position", function()
    local list = {one=1,two=2,three=3}
    
    assert.same(_.invert(list),{
      [1]="one",
      [2]="two",
      [3]="three"
    })

    assert.same(_.invert(_.invert(list)), list)
  end)
end)

describe("#functions", function()
  it("can grab the function names of any passed-in object", function()
    local list = {
      a='dash',
      b=_.map,
      c=123,
      d=_.reduce
    }

    assert.same(_.functions(list), {'b','d'})
  end)
end)

describe("#extend", function()
  it("can extend an object with attributes of another", function()
    assert.same(_.extend({},{b=1}, {b=1}))
  end)

  it("properties in source override destination", function()
    assert.same(_.extend({a=1},{a=2}),{a=2})
  end)

  it("properties not in source dont get overriden", function()
    assert.same(_.extend({a=1},{b=2}),{a=1,b=2})
  end)

  it("can extend from multiple source objects", function()
    assert.same(_.extend({a=1},{b=2},{c=3}),{a=1,b=2,c=3})
  end)

  it("extending from multiple source objects last property trumps", function()
    assert.same(_.extend({a=1},{b=2},{a=2}),{a=2,b=2})
  end)
end)

describe("#pick", function()
  it("can restrict properties to those named", function()
    assert.same(_.pick({a=1,b=2,c=3},'a','c'),{a=1,c=3})
  end)

  it("can restrict properties to those named in an array", function()
    assert.same(_.pick({a=1,b=2,c=3},{'b','c'}),{b=2,c=3})
  end)

  it("can restrict properties to those named in mixed args", function()
    assert.same(_.pick({a=1,b=2,c=3},{'b'},'c'),{b=2,c=3})
  end)
end)

describe("#omit", function()
  it("can omit a singled named property", function()
    assert.same(_.omit({a=1,b=2,c=3},'b'),{a=1,c=3})
  end)

  it("can moit several named properties", function()
    assert.same(_.omit({a=1,b=2,c=3},'a','c'),{b=2})
  end)

  it("can moit properties named in an array", function()
    assert.same(_.omit({a=1,b=2,c=3},{'b','c'}), {a=1})
  end)
end)

describe("#defaults", function()
  local list = {zero=0,one=1,empty="",nan=0/0,string="string"}

  it("does not override already set values", function()
    local result = _.defaults(list,{zero=1,one=10,twenty=20})
    assert.equals(result.zero, 0)
    assert.equals(result.one, 1)
    assert.equals(result.twenty, 20)
  end)

  it("handles multiple arguments by having first value win", function()
    local result = _.defaults(list, {word="word"},{word="dog"})
    assert.equals(result.word, "word")
  end)

  it("does not overide empty values", function()
    local result = _.defaults(list, {empty="full"},{nan="nan"})
    assert.equals(result.empty, "")
    assert.is.truthy(_.is_nan(result.nan))
  end)
end)

describe("#clone", function()
  local list = {name="moe",lucky={13,27,34}}

  it("has the attributes of the original", function()
    local result = _.clone(list)
    assert.is_not.equals(list, result)
    assert.same(list, result)
  end)

  it("can change shallow attrbiutes of the clone without effecting the original", function()
    local result = _.clone(list)
    result.name = "curly"
    assert.is_not.equals(result.name, list.name)
  end)

  it("can change deep attributes of the clone that effect the original", function()
    local result = _.clone(list)
    table.insert(result.lucky, 101)
    assert.equals(_.last(list.lucky), 101)
  end)

  it("does not change non objects", function()
    assert.equals(_.clone(nil),nil)
    assert.equals(_.clone(1),1)
    assert.equals(_.clone("string"),"string")
  end)
end)


describe("#is_equal", function()

end)

describe("#is_empty", function()
  it("returns false for non-empty values", function()
    assert.is_not.truthy(_.is_empty({1}))
    assert.is_not.truthy(_.is_empty({one=1}))
    assert.is_not.truthy(_.is_empty("string"))
    assert.is_not.truthy(_.is_empty(1))
  end)

  it("returns true for empty values", function()
    assert.truthy(_.is_empty({}))
    assert.truthy(_.is_empty(nil))
    assert.truthy(_.is_empty(''))
    assert.truthy(_.is_empty())
  end)
end)

describe("#is_object", function()
  it("returns true if table is object or array", function()
    assert.truthy(_.is_object({}))
    assert.truthy(_.is_object({1,2,3}))
    assert.truthy(_.is_object({one=1}))
    assert.truthy(_.is_object({one=1,two=2,three=3}))
    assert.truthy(_.is_object(function() end))
  end)

  it("returns false if not an object or array", function()
    assert.is_not.truthy(_.is_object(nil))
    assert.is_not.truthy(_.is_object("string"))
    assert.is_not.truthy(_.is_object(12))
    assert.is_not.truthy(_.is_object(true))
  end)
end)

describe("#is_array", function()
  it("returns true for array, not object", function()
    assert.is_not.truthy(_.is_array({}))
    assert.truthy(_.is_array({1,2,3}))
    assert.is_not.truthy(_.is_array({one=1,two=2,three=3}))
  end)

  it("returns false if not an object or array", function()
    assert.is_not.truthy(_.is_array(nil))
    assert.is_not.truthy(_.is_array("string"))
    assert.is_not.truthy(_.is_array(12))
    assert.is_not.truthy(_.is_array(true))
  end)
end)

describe("#is_string", function()
  it("returns true when a string", function()
    assert.truthy(_.is_string(""))
    assert.truthy(_.is_string("name"))
  end)

  it("returns false for non-string values", function()
    assert.is_not.truthy(_.is_string({}))
    assert.is_not.truthy(_.is_string(1))
    assert.is_not.truthy(_.is_string(nil))
    assert.is_not.truthy(_.is_string(true))
  end)
end)

describe("#is_number", function()
  it("returns true for any number", function()
    assert.truthy(_.is_number(1))
    assert.truthy(_.is_number(1.1))
    assert.truthy(_.is_number(math.huge))
    assert.truthy(_.is_number(-math.huge))
    assert.truthy(_.is_number(-1))
    assert.truthy(_.is_number(-1.1))
  end)

  it("returns false for non-number values", function()
    assert.is_not.truthy(_.is_number({}))
    assert.is_not.truthy(_.is_number(""))
    assert.is_not.truthy(_.is_number(nil))
    assert.is_not.truthy(_.is_number(true))
  end)
end)

describe("#is_nan", function()
  it("returns false for non NaN values", function()
    assert.is_not.truthy(_.is_nan(nil))
    assert.is_not.truthy(_.is_nan(0))
    assert.is_not.truthy(_.is_nan(""))
  end)

  it("returns true for the NaN values", function()
    assert.truthy(_.is_nan(0/0))
    
    local nan_value = 0/0
    assert.is_not.truthy(0/0==nan_value)
    assert.truthy(_.is_nan(nan_value))
  end)
end)

describe("#is_boolean", function()
  it("returns true for boolean value", function()
    assert.truthy(_.is_boolean(true))
    assert.truthy(_.is_boolean(false))
  end)

  it("returns false for non-boolean values", function()
    assert.is_not.truthy(_.is_number({}))
    assert.is_not.truthy(_.is_number(""))
    assert.is_not.truthy(_.is_number(nil))
    assert.is_not.truthy(_.is_number(function() end))
  end)
end)

describe("#is_function", function()
  it("returns true for boolean value", function()
    assert.truthy(_.is_function(function() end))
    assert.truthy(_.is_function(_.map))
    assert.truthy(_.is_function(function(v) return v end))
  end)

  it("returns false for non-boolean values", function()
    assert.is_not.truthy(_.is_function({}))
    assert.is_not.truthy(_.is_function(1))
    assert.is_not.truthy(_.is_function(""))
    assert.is_not.truthy(_.is_function(nil))
    assert.is_not.truthy(_.is_function(true))
  end)
end)

describe("#is_finite", function()
  it("returns true for numbers that are finite", function()
    assert.truthy(_.is_finite(1))
    assert.truthy(_.is_finite(100000))
    assert.truthy(_.is_finite(0))
    assert.truthy(_.is_finite(-100000))
  end)

  it("returns false for numbers that are not finite", function()
    assert.is_not.truthy(_.is_finite(math.huge))
    assert.is_not.truthy(_.is_finite(-math.huge))
  end)

  it("returns false for any non-number value", function()
    assert.is_not.truthy(_.is_finite({}))
    assert.is_not.truthy(_.is_finite(""))
    assert.is_not.truthy(_.is_finite(function() end))
    assert.is_not.truthy(_.is_finite(nil))
    assert.is_not.truthy(_.is_finite(true))
  end)
end)

describe("#is_nil", function()
  it("returns true if nil", function()
    assert.truthy(_.is_nil(nil))
    assert.truthy(_.is_nil())
  end)

  it("return false if non-nil value", function()
    assert.is_not.truthy(_.is_nil({}))
    assert.is_not.truthy(_.is_nil(""))
    assert.is_not.truthy(_.is_nil(function() end))
    assert.is_not.truthy(_.is_nil(123))
    assert.is_not.truthy(_.is_nil(true))
  end)
end)

describe("#tap", function()
  local intercepted = nil
  local interceptor = function(obj) intercepted = obj end
  local returned = _.tap(1, interceptor)

  it("passes the tapped object to interceptor", function()
    assert.equals(intercepted, 1)
    assert.equals(returned, 1)
  end)
end)
