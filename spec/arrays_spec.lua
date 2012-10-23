local _ = require("lib/underscore")

describe("#first", function()
  local numbers = {1,2,3}

  it("can pass an index to first", function()
    assert.same(_.first(numbers, 0), {})
    assert.same(_.first(numbers, 2), {1,2})
    assert.same(_.first(numbers, 5), {1,2,3})
  end)

  it("is aliased as #head and #take", function()
    assert.same(_.head(numbers, 2), {1,2})
    assert.same(_.take(numbers, 2), {1,2})
  end)

  it("handles nil", function()
    assert.same(_.first(nil), nil)
  end)
end)

describe("#rest", function()
  local numbers = {1,2,3,4}

  it("can take an index to rest", function()
    assert.same(_.rest(numbers), {2,3,4})
    assert.same(_.rest(numbers,1), {1,2,3,4})
    assert.same(_.rest(numbers,3), {3,4})
  end)

  it("is aliased as #drop and #tail", function()
    assert.same(_.drop(numbers), {2,3,4})
    assert.same(_.tail(numbers), {2,3,4})
  end)
end)

describe("#initial", function()
  it("can take an index to #initial", function()
    local numbers = {1,2,3,4,5}
    assert.same(_.initial(numbers), {1,2,3,4})
    assert.same(_.initial(numbers, 2), {1,2})
  end)
end)

describe("#last", function()
  local numbers = {1,2,3}

  it("can take an index to #last", function()
    assert.same(_.last(numbers), 3)
    assert.same(_.last(numbers, 0), {})
    assert.same(_.last(numbers, 2), {2,3})
    assert.same(_.last(numbers, 5), {1,2,3})
  end)

  it("handles nil", function()
    assert.same(_.last(nil), nil)
  end)
end)

describe("#compact", function()
  it("can trim falsy values", function()
    assert.same(_.compact({0,1,false,2,false,3}), {0,1,2,3})
  end)
end)

describe("#flatten", function()
  local list = {1, {2}, {3, {{4}}}}
  
  it("flattens nested arrays", function()
    assert.same(_.flatten(list), {1,2,3,4})
  end)

  it("flatten shallowly", function()
    assert.same(_.flatten(list, true), {1,2,3,{{4}}})
  end)
end)

describe("#without", function()
  it("can remove all instances of an object", function()
    local list = {1,2,1,0,3,1,4}
    assert.same(_.without(list, 0, 1), {2,3,4})
  end)

  it("uses object identity for comparison", function()
    local list = {{one=1},{two=2}}
    assert.same(_.without(list, {one=1}), {{one=1},{two=2}})
    assert.same(_.without(list, list[1]), {{two=2}})
  end)
end)

describe("#uniq", function()
  it("can find the uniq values of an unsorted array", function()
    local list = {1, 2, 1, 3, 1, 4}
    assert.same(_.uniq(list), {1,2,3,4})
  end)

  it("can find the uniq values of a sorted array", function()
    local list = {1, 1, 1, 2, 2, 3, 4}
    assert.same(_.uniq(list, true), {1,2,3,4})
  end)

  it("can find the unique values using a custom iterator", function()
    local list = {{name="moe"},{name="curly"},{name="larry"},{name="curly"}}
    local iterator = function(v) return v.name end
    assert.same(_.map(_.uniq(list, false, iterator), iterator), {"moe", "curly", "larry"})
  end)

  it("can use an iterator with a sorted array", function()
    local list = {1, 2, 2, 3, 4, 4}
    local iterator = function(v) return v + 1 end
    assert.same(_.uniq(list, true, iterator), {1,2,3,4})
  end)
end)

describe("#intersection", function()
  it("can take the set intersection of two arrays", function()
    local a = {"moe","curly","larry"}
    local b = {"moe","groucho"}
    assert.same(_.intersection(a,b), {"moe"})
  end)
end)

describe("#union", function()
  it("takes the union of a list of arrays", function()
    local result = _.union({1, 2, 3}, {2, 30, 1}, {1, 40})
    assert.same(result, {1,2,3,30,40})
  end)

  it("takes the union of a list of nested arrays", function()
    local result = _.union({1, 2, 3}, {2, 30, 1}, {1, 40, {1}})
    assert.same(result, {1,2,3,30,40,{1}})
  end)
end)

describe("#difference", function()
  it("takes the difference of two arrays", function()
    assert.same(_.difference({1,2,3},{2,30,40}), {1,3})
  end)

  it("takes the difference of three arrays", function()
    assert.same(_.difference({1, 2, 3, 4}, {2, 30, 40}, {1, 11, 111}), {3, 4})
  end)
end)

describe("#zip", function()
  it("zipped together arrays of different lengths", function()
    local names = {"moe","larry","curly"}
    local ages = {30,40,50}
    local leaders = {true}

    assert.same(_.zip(names, ages, leaders), {
      {"moe",30,true},
      {"larry",40},
      {"curly",50}
    })
  end)
end)

describe("#object", function()
  it("zips two arrays together into an object", function()
    local result = _.object({'moe', 'larry', 'curly'}, {30, 40, 50})
    assert.same(result, {["moe"]=30,["larry"]=40,["curly"]=50})
  end)

  it("returns an empty list", function()
    assert.same(_.object(), {})
    assert.same(_.object(nil), {})
  end)

  it("zips an array of pairs together into an object", function()
    local result = _.object({{'one', 1}, {'two', 2}, {'three', 3}})
    assert.same(result, {["one"]=1,["two"]=2,["three"]=3})
  end)
end)

describe("#indexOf", function()
  it("can compute index of a value", function()
    local list = {1,2,3}
    assert.same(_.indexOf(list, 2), 2)
    assert.same(_.indexOf(list, 5), 0)
  end)

  it("support starting from an index", function()
    local list = {1, 2, 3, 1, 2, 3, 1, 2, 3}
    assert.same(_.indexOf(list, 2, 6), 8)
  end)
  
  it("handles nil properly", function()
    assert.equal(_.indexOf(nil, 0), 0)
  end)
end)

describe("#lastIndexOf", function()
  local numbers = {1, 0, 1, 0, 0, 1, 0, 0, 0}

  it("returns the last index from the right the element appears", function()
    assert.equal(_.lastIndexOf(numbers, 1), 6)
    assert.equal(_.lastIndexOf(numbers, 0), 9)
  end)

  it("supports starting from an index", function()
    assert.equal(_.lastIndexOf(numbers, 10), 0)
  end)

  it("handles nil properly", function()
    assert.equal(_.lastIndexOf(nil, 0), 0)
  end)
end)

describe("#range", function()
  it("generates an empty array", function()
    assert.same(_.range(), {})
    assert.same(_.range(0), {})
  end)

  it("generates a range for a positive integer", function()
    assert.same(_.range(4), {0,1,2,3})
  end)

  it("generates a range between a & b where a < b", function()
    assert.same(_.range(5,8), {5,6,7})
  end)

  it("generates an empty array when a & b where b > a", function()
    assert.same(_.range(8,5), {})
  end)

  it("generates a range between a < b stepping with c", function()
    assert.same(_.range(3,10,3), {3,6,9})
  end)

  it("generates an empty array when a < b with c > b", function()
    assert.same(_.range(3,10,15), {3})
  end)

  it("generates a range where a > b stepping with c", function()
    assert.same(_.range(12,7,-2), {12,10,8})
  end)

  it("does the final exmaple in the Python docs", function()
    assert.same(_.range(0,-10, -1), {0,-1,-2,-3,-4,-5,-6,-7,-8,-9})
  end)
end)
