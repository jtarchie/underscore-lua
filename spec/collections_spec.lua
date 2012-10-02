local _ = require("lib/underscore")

describe("#each", function()
  it("provides the value and iteration count", function()
    local array = {}
    _.each({1,2,3}, function(value, index)
      assert.equals(value, index)
      table.insert(array, value)
    end)
    assert.same({1,2,3}, array)
  end)

  it("can reference the orignal table", function()
    _.each({1,2,3}, function(value, index, array)
      assert.equals(array[index], value)
    end)
  end)

  it("can iterate over objects", function()
    local array = {}
    _.each({one=1,two=2,three=3}, function(value)
      table.insert(array, value)
    end)
    assert.same({3,1,2}, array)
  end)
end)

describe("#map", function()
  it("doubled the numbers", function()
    local values = _.map({1,2,3}, function(i) return i * 2 end)
    assert.same(values, {2,4,6})
  end)

  it("aliased to #collect", function()
    local values = _.collect({1,2,3}, function(i) return i * 2 end)
    assert.same(values, {2,4,6})
  end)
end)

describe("#reduce", function()
  it("sums up values", function()
    local sum = _.reduce({1,2,3}, function(sum, value) return sum + value end, 0)
    assert.equals(sum, 6)
  end)

  it("has a default initial value for the first value", function()
    local sum = _.reduce({2,3,4}, function(sum, value) return sum + value end)
    assert.equals(sum, 9)
  end)

  it("has a default value with an object", function()
    local sum = _.reduce({foo=1,bar=2,baz=3}, function(memo, str) return memo + str end)
    assert.equals(sum, 6)
  end)

  it("aliased to #inject", function()
    local sum = _.inject({1,2,3}, function(sum, value) return sum + value end, 0)
    assert.equals(sum, 6)
  end)

  it("aliased to #foldl", function()
    local sum = _.foldl({1,2,3}, function(sum, value) return sum + value end, 0)
    assert.equals(sum, 6)
  end)

  it("raises an error with empty array and no initial value", function()
    assert.error(function()
      _.reduce({})
    end)
  end)
end)

describe("#reduceRight", function()
  it("can reduce from the right", function()
    local list = _.reduceRight({"foo","bar","baz"}, function(memo, str) return memo .. str end, "")
    assert.equals(list, "bazbarfoo")
  end)

  it("has a default inital value for the first value", function()
    local list = _.reduceRight({"foo","bar","baz"}, function(memo, str) return memo .. str end)
    assert.equals(list, "bazbarfoo")
  end)

  it("aliased as #foldr", function()
    local list = _.foldr({"foo","bar","baz"}, function(memo, str) return memo .. str end)
    assert.equals(list, "bazbarfoo")
  end)

  it("has a default value with an object", function()
    local sum = _.reduceRight({foo=1,bar=2,baz=3}, function(memo, str) return memo + str end)
    assert.equals(sum, 6)
  end)

  it("raises an error with empty array and no initial value", function()
    assert.error(function()
      _.reduceRight({})
    end)
  end)
end)

describe("#find", function()
  local array = {1,2,3,4}

  it("returns the first found value", function()
    local value = _.find(array, function(n) return n > 2 end)
    assert.equals(value, 3)
  end)

  it("returns nil if value is not found", function()
    local value = _.find(array, function(n) return false end)
    assert.equals(value, nil)
  end)

  it("aliased as #detect", function()
    local value = _.detect(array, function(n) return n > 2 end)
    assert.equals(value, 3)
  end)
end)
