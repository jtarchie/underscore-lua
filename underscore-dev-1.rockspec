package = "underscore"
version = "dev-1"
source = {
  url = "git://github.com/jtarchie/underscore-lua.git"
}
description = {
  summary = "Underscore is a utility-belt library for Lua",
  detailed = [[
    underscore-lua is a utility-belt library for Lua that provides a lot of the functional programming support that you would expect in or Ruby's Enumerable.
  ]],
  homepage = "http://jtarchie.github.com/underscore-lua/",
  maintainer = "JT Archie <jtarchie@gmail.com>",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    underscore = "lib/underscore.lua"
  }
}
