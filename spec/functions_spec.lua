local _ = require("lib/underscore")

describe("#memoize", function()
  function fib(n)
    if n < 2 then
      return n
    else
      return fib(n - 1) + fib(n - 2)
    end
  end

  it("returns a value of fib", function()
    local fast_fib = _.memoize(fib)
    assert.equal(fib(10), 55)
    assert.equal(fast_fib(10), 55)
  end)
end)

describe("#once", function()
  it("only invokes the function once", function()
    local num = 0
    local incr = _.once(function() num = num + 1 end)

    incr()
    incr()

    assert.equal(num, 1)
  end)
end)

describe("#after", function()
  local test_after = function(after_amount, times_called)
    local after_called = 0
    local after = _.after(after_amount, function()
      after_called = after_called + 1
    end)

    while times_called > 0 do
      after()
      times_called = times_called - 1
    end

    return after_called
  end

  it("should be called N times", function()
    assert.equal(test_after(5,5), 1)
  end)

  it("should not be called until N times", function()
    assert.equal(test_after(5,4), 0)
  end)

  it("should fire immediately", function()
    assert.equal(test_after(0,0), 1)
  end)
end)

describe("#bind", function()
  local table = {name = "moe"}
  local greet = function(self) return "hi: " .. self.name end
  it("returns a closure that binds a function to a table scope ", function()
    local binded = _.bind(greet, table)
    assert.equals(binded(), "hi: moe")
  end)
end)

describe("#wrap", function()
  it("passes arguments ", function()
    local greet = function(name) return "hi: " .. name end
    local backwards = _.wrap(greet, function(func, name)
      return func(name) .. " " ..  string.reverse(name)
    end)

    assert.equals(backwards("moe"), "hi: moe eom")
  end)
end)

describe("#compose", function()
  local greet = function(name) return "hi: " .. name end
  local exclaim = function(sentence) return sentence .. "!" end

  it("can compose a function that takes another", function()
    local composed = _.compose(greet, exclaim)
    assert.equal(composed("moe"), "hi: moe!")
  end)

  it("compose functions that are commutative", function()
    local composed = _.compose(exclaim, greet)
    assert.equal(composed("moe"), "hi: moe!")
  end)

  it("compes multiple functions", function()
    local quoted = function(sentence) return "'" .. sentence .. "'" end
    local composed = _.compose(quoted, exclaim, greet)
    assert.equal(composed("moe"), "'hi: moe!'")
  end)
end)
