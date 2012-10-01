local table = require("table")

module(..., package.seeall)

function each(values, func)
  local pairing = pairs
  if values[1] then pairing = ipairs end

  for index, value in pairing(values) do
    func(value, index, values)
  end
end

function map(values, func)
  local new_values = {}
  each(values, function(value)
    table.insert(new_values, func(value))
  end)

  return new_values
end

collect = map
