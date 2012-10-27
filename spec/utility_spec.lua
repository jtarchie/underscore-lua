local _ = require("lib/underscore")

describe("_ as a function", function()
  it("return the original instance", function()
    local instance = _({1,2,3})
    assert.equal(_(instance), instance)
  end)
end)

describe("#identity", function()
  it("return the value passed in", function()
    local moe = {name="moe"}
    assert.same(_.identity(moe), moe)
  end)
end)

describe("#uniqueId", function()
  it("can generate a globally-unique stream of ids", function()
    local ids = {}
    for i=1,100,1 do table.insert(ids, _.uniqueId()) end
    assert.same(_.uniq(ids),ids)
  end)
end)

describe("#times", function()
  it("is 0 indexed", function()
    local vals = {};
    _.times(3, function (i)  table.insert(vals, i) end)
    assert.same(vals, {0,1,2});
  end)
  it("works as a wrapper", function()
    local vals = {}
    _(3):times(function (i) table.insert(vals, i) end);
    assert.same(vals, {0,1,2})
  end)
end)

describe("#mixin", function()
  _.mixin({
    myReverse=function(string)
      return table.concat(_(string).chain():split():reverse():value())
    end
  })

  it("mixed in a function to _", function()
    assert.equal(_.myReverse('panacea'),'aecanap')
    assert.equal(_('champ').chain():myReverse():value(), 'pmahc')
  end)
end)

describe("#escape", function()
  it("handles escaping of HTML special characters", function()
    assert.equals(_.escape("Curly & Moe"), "Curly &amp; Moe")
    assert.equals(_.escape("& < > \" ' /"),"&amp; &lt; &gt; &quot; &#x27; &#x2F;")
    assert.equals(_.escape("Curly &amp; Moe"), "Curly &amp;amp; Moe")
    assert.equals(_.escape(nil), '')
    assert.equals(_.escape(_.unescape("Curly &amp; Moe")), "Curly &amp; Moe")
  end)
end)

describe("#unescape", function()
  it("handles unescaping of HTML special characters", function()
    assert.equals(_.unescape("Curly &amp; Moe"), "Curly & Moe")
    assert.equals(_.unescape("Curly &amp;amp; Moe"), "Curly &amp; Moe")
    assert.equals(_.unescape(nil), "")
    assert.equals(_.unescape("&amp; &lt; &gt; &quot; &#x27; &#x2F;"), "& < > \" ' /")
  end)
end)

describe("#result", function()
  local obj = {w="",x="x",y=function(obj) return obj.x end}

  it("calls the function and returns result", function()
    assert.same(_.result(obj, 'y'), 'x')
  end)

  it("returns the primitive result", function()
    assert.same(_.result(obj, 'w'), '')
    assert.same(_.result(obj, 'x'), 'x')
  end)

  it("defaults to nil with unknown values", function()
    assert.same(_.result(obj, 'z'), nil)
  end)
end)
