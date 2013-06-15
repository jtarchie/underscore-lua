local _ = require("lib/underscore")

describe("string functions", function()
  describe("#split", function()
    it("splits a string on each character", function()
      assert.same(_.split("asdf"),{"a","s","d","f"})
      assert.same(_.split(""),{})
    end)

    it("returns an empty array with non-string values", function()
      assert.same(_.split({}),{})
      assert.same(_.split(nil),{})
      assert.same(_.split(123),{})
      assert.same(_.split(function() end),{})
    end)

    describe("with a specific split string", function()
      it("can split a specific characters", function()
        assert.same(_.split("a|b|c|d", "|"), {"a","b","c","d"})
        assert.same(_.split("a 1 c 2", " "), {"a","1","c","2"})
        assert.same(_.split("a\tb\tc\td", "\t"), {"a","b","c","d"})
      end)

      it("can split using Lua pattern matchers", function()
        assert.same(_.split("a   b c     d", "%s+"), {"a","b","c","d"})
        assert.same(_.split("a1b2c3d4e", "%d"), {"a","b","c","d","e"})
      end)

      it("can split on whole words", function()
        assert.same(_.split("arabbitbrabbitc", "rabbit"), {"a","b","c"})
      end)
    end)

    describe("#capitalize", function()
      it("capitalizes only the first letter", function()
        assert.same(_.capitalize('fabio'), 'Fabio');
        assert.same(_.capitalize('FOO'), 'FOO');
        assert.same(_(123):capitalize(), '123');
        assert.same(_.capitalize(''), '');
        assert.same(_.capitalize(nil), '');
      end)
    end)

    describe("#numberFormat", function()
      it("formats a number to the decimal place", function()
        assert.same(_.numberFormat(9000), '9,000');
        assert.same(_.numberFormat(9000, 0), '9,000');
        assert.same(_.numberFormat(9000, 0, '', ''), '9000');
        assert.same(_.numberFormat(90000, 2), '90,000.00');
        assert.same(_.numberFormat(1000.754), '1,001');
        assert.same(_.numberFormat(1000.754, 2), '1,000.75');
        assert.same(_.numberFormat(1000.754, 0, ',', '.'), '1.001');
        assert.same(_.numberFormat(1000.754, 2, ',', '.'), '1.000,75');
        assert.same(_.numberFormat(1000000.754, 2, ',', '.'), '1.000.000,75');
        assert.same(_.numberFormat(1000000000), '1,000,000,000');
        assert.same(_.numberFormat(100000000), '100,000,000');
        assert.same(_.numberFormat('not number'), '');
        assert.same(_.numberFormat(), '');
        assert.same(_.numberFormat(null, '.', ','), '');
      end)
    end)
  end)
end)
