local _ = require("lib/underscore")

describe("chaining of methods", function()
  describe("with #map, #flatten, and #reduce", function()
    local lyrics = {
      "I'm a lumberjack and I'm okay",
      "I sleep all night and I work all day",
      "He's a lumberjack and he's okay",
      "He sleeps all night and he works all day"
    }

    it("counted all the letters in a song", function()
      local counts = _(lyrics).chain()
        .map(function(line) return _.split(line) end)
        .flatten()
        .reduce(function(hash, l)
          hash[l] = hash[l] or 0
          hash[l] = hash[l] + 1
          return hash
        end, {}).value()
        
        assert.equals(counts['a'], 16)
        assert.equals(counts['e'], 10)
    end)
  end)

  describe("with #select, #reject, #sortBy", function()
    local numbers = {1,2,3,4,5,6,7,8,9,10}

    it("filtered and reversed the numbers", function()
      numbers = _(numbers).chain().select(function(n)
        return n % 2 ==0
      end).reject(function(n)
        return n % 4 == 0
      end).sortBy(function(n)
        return -n
      end).value()

      assert.same(numbers, {10,6,2})
    end)
  end)

  describe("with #select, #reject, #sortBy in functional style", function()
    local numbers = {1,2,3,4,5,6,7,8,9,10}

    it("filtered and reversed the numbers", function()
      numbers = _.chain(numbers).select(function(n)
        return n % 2 ==0
      end).reject(function(n)
        return n % 4 == 0
      end).sortBy(function(n)
        return -n
      end).value()

      assert.same(numbers, {10,6,2})
    end)
  end)

  pending("with #reverse, #concat, #unshift, #pop, #map", function()
    local numbers = {1,2,3,4,5}

    it("can chain together array functions", function()
      numbers = _(numbers).chain()
        .reverse()
        .contact({5,5,5})
        .unshift(17)
        .pop()
        .map(function(n) return n * 2 end)
        .value()

        assert.same(numbers, {34,10,8,6,4,2,10,10})
    end)
  end)
end)
