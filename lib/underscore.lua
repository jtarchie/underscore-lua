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

function select(values, func)
  local found = {}
  each(values, function(value)
    if func(value) then
      table.insert(found, value)
    end
  end)

  return found
end

function reject(values, func)
  local found = {}
  each(values, function(value)
    if not func(value) then
      table.insert(found, value)
    end
  end)

  return found
end

function all(values, func)
  if next(values) == nil then return false end

  func = func or function(value) return value end

  local found = true
  each(values, function(value)
    if found and not func(value) then
      found = false
    end
  end)

  return found
end

function any(values, func)
  if next(values) == nil then return false end

  func = func or function(value) return value end

  local found = false
  each(values, function(value)
    if not found and func(value) then
      found = true
    end
  end)

  return found
end

-- private

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
filter = select
every = all
same = any
