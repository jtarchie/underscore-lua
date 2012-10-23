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
    assert.same(_.extend({},{b=1}), {b=1})
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
    assert.is.truthy(_.isNaN(result.nan))
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


describe("#isEqual", function()

end)

describe("#isEmpty", function()
  it("returns false for non-empty values", function()
    assert.is_not.truthy(_.isEmpty({1}))
    assert.is_not.truthy(_.isEmpty({one=1}))
    assert.is_not.truthy(_.isEmpty("string"))
    assert.is_not.truthy(_.isEmpty(1))
  end)

  it("returns true for empty values", function()
    assert.truthy(_.isEmpty({}))
    assert.truthy(_.isEmpty(nil))
    assert.truthy(_.isEmpty(''))
    assert.truthy(_.isEmpty())
  end)
end)

describe("#isObject", function()
  it("returns true if table is object or array", function()
    assert.truthy(_.isObject({}))
    assert.truthy(_.isObject({1,2,3}))
    assert.truthy(_.isObject({one=1}))
    assert.truthy(_.isObject({one=1,two=2,three=3}))
    assert.truthy(_.isObject(function() end))
  end)

  it("returns false if not an object or array", function()
    assert.is_not.truthy(_.isObject(nil))
    assert.is_not.truthy(_.isObject("string"))
    assert.is_not.truthy(_.isObject(12))
    assert.is_not.truthy(_.isObject(true))
  end)
end)

describe("#isArray", function()
  it("returns true for array, not object", function()
    assert.is_not.truthy(_.isArray({}))
    assert.truthy(_.isArray({1,2,3}))
    assert.is_not.truthy(_.isArray({one=1,two=2,three=3}))
  end)

  it("returns false if not an object or array", function()
    assert.is_not.truthy(_.isArray(nil))
    assert.is_not.truthy(_.isArray("string"))
    assert.is_not.truthy(_.isArray(12))
    assert.is_not.truthy(_.isArray(true))
  end)
end)

describe("#isString", function()
  it("returns true when a string", function()
    assert.truthy(_.isString(""))
    assert.truthy(_.isString("name"))
  end)

  it("returns false for non-string values", function()
    assert.is_not.truthy(_.isString({}))
    assert.is_not.truthy(_.isString(1))
    assert.is_not.truthy(_.isString(nil))
    assert.is_not.truthy(_.isString(true))
  end)
end)

describe("#isNumber", function()
  it("returns true for any number", function()
    assert.truthy(_.isNumber(1))
    assert.truthy(_.isNumber(1.1))
    assert.truthy(_.isNumber(math.huge))
    assert.truthy(_.isNumber(-math.huge))
    assert.truthy(_.isNumber(-1))
    assert.truthy(_.isNumber(-1.1))
  end)

  it("returns false for non-number values", function()
    assert.is_not.truthy(_.isNumber({}))
    assert.is_not.truthy(_.isNumber(""))
    assert.is_not.truthy(_.isNumber(nil))
    assert.is_not.truthy(_.isNumber(true))
  end)
end)

describe("#isNaN", function()
  it("returns false for non NaN values", function()
    assert.is_not.truthy(_.isNaN(nil))
    assert.is_not.truthy(_.isNaN(0))
    assert.is_not.truthy(_.isNaN(""))
  end)

  it("returns true for the NaN values", function()
    assert.truthy(_.isNaN(0/0))
    
    local nan_value = 0/0
    assert.is_not.truthy(0/0==nan_value)
    assert.truthy(_.isNaN(nan_value))
  end)
end)

describe("#isBoolean", function()
  it("returns true for boolean value", function()
    assert.truthy(_.isBoolean(true))
    assert.truthy(_.isBoolean(false))
  end)

  it("returns false for non-boolean values", function()
    assert.is_not.truthy(_.isBoolean({}))
    assert.is_not.truthy(_.isBoolean(""))
    assert.is_not.truthy(_.isBoolean(nil))
    assert.is_not.truthy(_.isBoolean(function() end))
  end)
end)

describe("#isFunction", function()
  it("returns true for boolean value", function()
    assert.truthy(_.isFunction(function() end))
    assert.truthy(_.isFunction(_.map))
    assert.truthy(_.isFunction(function(v) return v end))
  end)

  it("returns false for non-boolean values", function()
    assert.is_not.truthy(_.isFunction({}))
    assert.is_not.truthy(_.isFunction(1))
    assert.is_not.truthy(_.isFunction(""))
    assert.is_not.truthy(_.isFunction(nil))
    assert.is_not.truthy(_.isFunction(true))
  end)
end)

describe("#isFinite", function()
  it("returns true for numbers that are finite", function()
    assert.truthy(_.isFinite(1))
    assert.truthy(_.isFinite(100000))
    assert.truthy(_.isFinite(0))
    assert.truthy(_.isFinite(-100000))
  end)

  it("returns false for numbers that are not finite", function()
    assert.is_not.truthy(_.isFinite(math.huge))
    assert.is_not.truthy(_.isFinite(-math.huge))
  end)

  it("returns false for any non-number value", function()
    assert.is_not.truthy(_.isFinite({}))
    assert.is_not.truthy(_.isFinite(""))
    assert.is_not.truthy(_.isFinite(function() end))
    assert.is_not.truthy(_.isFinite(nil))
    assert.is_not.truthy(_.isFinite(true))
  end)
end)

describe("#isNil", function()
  it("returns true if nil", function()
    assert.truthy(_.isNil(nil))
    assert.truthy(_.isNil())
  end)

  it("return false if non-nil value", function()
    assert.is_not.truthy(_.isNil({}))
    assert.is_not.truthy(_.isNil(""))
    assert.is_not.truthy(_.isNil(function() end))
    assert.is_not.truthy(_.isNil(123))
    assert.is_not.truthy(_.isNil(true))
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
