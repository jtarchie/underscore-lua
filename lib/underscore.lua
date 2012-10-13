local table, ipairs, pairs, math, string = table, ipairs, pairs, math, string

module(..., package.seeall)

-- private
local identity = function(value) return value end

local reverse = function(values)
  local reversed = {}
  each(values, function(value, index)
    table.insert(reversed, 1, value)
  end)

  return reversed
end

local is_empty = function(values)
  return next(values) == nil
end

local is_object = function(values)
  return type(values) == "table"
end

local is_string = function(value)
  return type(value) == "string" 
end

local is_function = function(value)
  return type(value) == "function"
end

local is_array = function(values)
  return is_object(values) and values[1]
end


-- public 
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
  if is_empty(values) then return false end

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
  elseif is_function(func) then
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
  elseif is_function(func) then
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

function invoke(values, func, ...)
  local invoke_func, args = func, {...}
  
  if is_string(func) then
    invoke_func = function(value, ...)
      return value[func](value, unpack(args))
    end
  end

  return collect(values, function(value)
    return invoke_func(value, unpack(args))
  end)
end

function sort_by(values, func)
  func = func or identity
  local sorted_func = function(a,b)
    if a == nil then return false end
    if b == nil then return true end
    return func(a) < func(b)
  end

  if is_string(func) then
    sorted_func = function(a,b)
      return a[func](a) < b[func](b)
    end
  end

  table.sort(values, sorted_func)
  return values
end

function group_by(values, func)
  local group_func, result = func, {}

  if is_string(func) then
    group_func = function(v)
      return v[func](v)
    end
  end

  each(values, function(value)
    local key = group_func(value)
    result[key] = result[key] or {}
    table.insert(result[key], value)
  end)

  return result
end

function count_by(values, func)
  local count_func, result = func, {}

  if is_string(func) then
    count_func = function(v)
      return v[func](v)
    end
  end

  each(values, function(value)
    local key = count_func(value)
    result[key] = result[key] or 0 
    result[key] = result[key] + 1
  end)

  return result
end

function shuffle(values)
  local rand, index, shuffled = 0, 1, {}
  each(values, function(value)
    rand = math.random(1, index)
    index = index + 1
    shuffled[index - 1] = shuffled[rand]
    shuffled[rand] = value
  end)

  return shuffled
end

function to_array(values)
  if not values then return {} end
  
  local cloned = {}
  each(values, function(value)
    table.insert(cloned, value)
  end)

  return cloned
end

function size(values, ...)
  local args = {...}

  if is_array(values) then
    return #values
  elseif is_object(values) then
    local length = 0
    each(values, function() length = length + 1 end)
    return length
  elseif is_string(values) then
    return string.len(values)
  elseif not is_empty(args) then
    return size(args) + 1
  end

  return 0
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
