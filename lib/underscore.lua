local table, ipairs, pairs, math = table, ipairs, pairs, math 

module(..., package.seeall)

local identity = function(value) return value end

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

  func = func or identity

  local found = true
  each(values, function(value, index)
    if found and not func(value, index) then
      found = false
    end
  end)

  return found
end

function any(values, func)
  if is_empty(values) then return false end

  func = func or identity

  local found = false
  each(values, function(value, index)
    if not found and func(value, index) then
      found = true
    end
  end)

  return found
end

function include(values, v)
  return any(values, function(value)
    return v == value
  end)
end

function pluck(values, key)
  local found = {}
  each(values, function(value)
    table.insert(found, value[key])
  end)

  return found
end

function where(values, properties)
  local found = {}
  return select(values, function(value)
    return all(properties, function(v, k)
      return value[k] == v
    end)
  end)
end

function max(values, func)
  if is_empty(values) then
    return -math.huge
  elseif type(func) == "function" then
    local max = {computed=-math.huge}
    each(values, function(value)
      local computed = func(value)
      if computed >= max.computed then
        max = {computed=computed, value=value}
      end
    end)
    return max.value
  else
    return math.max(unpack(values))
  end
end

function min(values, func)
  if is_empty(values) then
    return math.huge
  elseif type(func) == "function" then
    local min = {computed=math.huge}
    each(values, function(value)
      local computed = func(value)
      if computed < min.computed then
        min = {computed=computed, value=value}
      end
    end)
    return min.value
  else
    return math.min(unpack(values))
  end
end

-- private

function reverse(values)
  local reversed = {}
  each(values, function(value, index)
    table.insert(reversed, 1, value)
  end)

  return reversed
end

function is_empty(values)
  return next(values) == nil
end

collect = map
inject = reduce
foldl = reduce
foldr = reduceRight
detect = find
filter = select
every = all
same = any
contains = include
