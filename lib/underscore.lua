local table, ipairs, pairs = table, ipairs, pairs 

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

function reduce(values, func, memo)
  local init = memo == nil
  each(values, function(value)
    if init then
      memo = value
      init = false
    else
      memo = func(memo, value)
    end
  end)

  if init then
    error("Reduce of empty array with no initial value")
  end

  return memo
end

function reduceRight(values, func, memo)
  local init = memo == nil
  each(reverse(values), function(value)
    if init then
      memo = value
      init = false
    else
      memo = func(memo, value)
    end
  end)

  if init then
    error("Reduce of empty array with no initial value")
  end

  return memo
end

function find(values, func)
  if func == nil then return nil end

  local result = nil
  any(values, function(value)
    if func(value) then
      result = value
      return true
    end
  end)

  return result 
end

-- private

function any(values, func)
  local found = false
  each(values, function(value)
    if not found and func(value) then
      found = true
    end
  end)

  return found
end

function reverse(values)
  local reversed = {}
  each(values, function(value, index)
    table.insert(reversed, 1, value)
  end)

  return reversed
end

collect = map
inject = reduce
foldl = reduce
foldr = reduceRight
detect = find 
