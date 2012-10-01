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

  it("aliased to collect", function()
    local values = _.collect({1,2,3}, function(i) return i * 2 end)
    assert.same(values, {2,4,6})
  end)
end)
