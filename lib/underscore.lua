local table, ipairs, pairs, math, string = table, ipairs, pairs, math, string

--module(..., package.seeall)

local _ = {}

-- private
local identity = function(value) return value end

local reverse = function(list)
  local reversed = {}
  _.each(list, function(value, index)
    table.insert(reversed, 1, value)
  end)

  return reversed
end

local slice = function(list, start, stop)
  local array = {}

  for index = start, stop, 1 do
    table.insert(array, list[index])
  end

  return array
end

-- public 
function _.each(list, func)
  local pairing = pairs
  if list[1] then pairing = ipairs end

  for index, value in pairing(list) do
    func(value, index, list)
  end
end

function _.map(list, func)
  local new_list = {}
  _.each(list, function(value, key, original_list)
    table.insert(new_list, func(value, key, original_list))
  end)

  return new_list
end

function _.reduce(list, func, memo)
  local init = memo == nil
  _.each(list, function(value)
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

function _.reduceRight(list, func, memo)
  local init = memo == nil
  _.each(reverse(list), function(value)
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

function _.find(list, func)
  if func == nil then return nil end

  local result = nil
  _.any(list, function(value)
    if func(value) then
      result = value
      return true
    end
  end)

  return result 
end

function _.select(list, func)
  local found = {}
  _.each(list, function(value)
    if func(value) then
      table.insert(found, value)
    end
  end)

  return found
end

function _.reject(list, func)
  local found = {}
  _.each(list, function(value)
    if not func(value) then
      table.insert(found, value)
    end
  end)

  return found
end

function _.all(list, func)
  if _.is_empty(list) then return false end

  func = func or identity

  local found = true
  _.each(list, function(value, index)
    if found and not func(value, index) then
      found = false
    end
  end)

  return found
end

function _.any(list, func)
  if _.is_empty(list) then return false end

  func = func or identity

  local found = false
  _.each(list, function(value, index)
    if not found and func(value, index) then
      found = true
    end
  end)

  return found
end

function _.include(list, v)
  return _.any(list, function(value)
    return v == value
  end)
end

function _.pluck(list, key)
  local found = {}
  _.each(list, function(value)
    table.insert(found, value[key])
  end)

  return found
end

function _.where(list, properties)
  local found = {}
  return _.select(list, function(value)
    return _.all(properties, function(v, k)
      return value[k] == v
    end)
  end)
end

function _.max(list, func)
  if _.is_empty(list) then
    return -math.huge
  elseif _.is_function(func) then
    local max = {computed=-math.huge}
    _.each(list, function(value)
      local computed = func(value)
      if computed >= max.computed then
        max = {computed=computed, value=value}
      end
    end)
    return max.value
  else
    return math.max(unpack(list))
  end
end

function _.min(list, func)
  if _.is_empty(list) then
    return math.huge
  elseif _.is_function(func) then
    local min = {computed=math.huge}
    _.each(list, function(value)
      local computed = func(value)
      if computed < min.computed then
        min = {computed=computed, value=value}
      end
    end)
    return min.value
  else
    return math.min(unpack(list))
  end
end

function _.invoke(list, func, ...)
  local invoke_func, args = func, {...}
  
  if _.is_string(func) then
    invoke_func = function(value)
      return value[func](value, unpack(args))
    end
  end

  return _.collect(list, function(value)
    return invoke_func(value, unpack(args))
  end)
end

function _.sort_by(list, func)
  func = func or identity
  local sorted_func = function(a,b)
    if a == nil then return false end
    if b == nil then return true end
    return func(a) < func(b)
  end

  if _.is_string(func) then
    sorted_func = function(a,b)
      return a[func](a) < b[func](b)
    end
  end

  table.sort(list, sorted_func)
  return list
end

function _.group_by(list, func)
  local group_func, result = func, {}

  if _.is_string(func) then
    group_func = function(v)
      return v[func](v)
    end
  end

  _.each(list, function(value)
    local key = group_func(value)
    result[key] = result[key] or {}
    table.insert(result[key], value)
  end)

  return result
end

function _.count_by(list, func)
  local count_func, result = func, {}

  if _.is_string(func) then
    count_func = function(v)
      return v[func](v)
    end
  end

  _.each(list, function(value)
    local key = count_func(value)
    result[key] = result[key] or 0 
    result[key] = result[key] + 1
  end)

  return result
end

function _.shuffle(list)
  local rand, index, shuffled = 0, 1, {}
  _.each(list, function(value)
    rand = math.random(1, index)
    index = index + 1
    shuffled[index - 1] = shuffled[rand]
    shuffled[rand] = value
  end)

  return shuffled
end

function _.to_array(list)
  if not list then return {} end
  
  local cloned = {}
  _.each(list, function(value)
    table.insert(cloned, value)
  end)

  return cloned
end

function _.size(list, ...)
  local args = {...}

  if _.is_array(list) then
    return #list
  elseif _.is_object(list) then
    local length = 0
    _.each(list, function() length = length + 1 end)
    return length
  elseif _.is_string(list) then
    return string.len(list)
  elseif not _.is_empty(args) then
    return _.size(args) + 1
  end

  return 0
end

function _.memoize(func)
  local list = {}

  return function(...)
    if not list[...] then
       list[...] = func(...)
    end

    return list[...]
  end
end

function _.once(func)
  local called = false
  return function(...)
    if not called then
      called = true
      return func(...)
    end
  end
end

function _.after(times, func)
  if times <= 0 then return func() end

  return function(...)
    times = times - 1
    if times < 1 then
      return func(...)
    end
  end
end

function _.wrap(func, wrapper)
  return function(...)
    wrapper(func, ...)
  end
end

function _.compose(...)
  local funcs = {...}

  return function(...)
    local args = {...}

    _.each(reverse(funcs), function(func)
      table.insert(args, func(unpack(args)))
    end)

    return args[0]
  end
end

function _.range(...)
  local args = {...}
  local start, stop, step = unpack(args)
  
  if #args <= 1 then
    stop = start or 0
    start = 0
  end
  step = args[3] or 1

  local length, index, array =
    math.max(math.ceil((stop - start) / step), 0),
    0, {}

  while index < length do
    table.insert(array, start)
    index = index + 1
    start = start + step
  end
  
  return array
end

function _.first(list, count)
  if not list then return nil end
  count = count or 1

  return slice(list, 1, count)
end

function _.rest(list, start)
  start = start or 2

  return slice(list, start, #list)
end

function _.initial(list, stop)
  stop = stop or (#list - 1)

  return slice(list, 1, stop)
end

function _.last(list, count)
  if not list then return nil end

  if not count then
    return list[#list]
  else
    local start, stop, array = #list - count + 1, #list, {}
    return slice(list, start, stop)
  end
end

function _.compact(list)
  return _.filter(list, function(v)
    return not not v
  end)
end

function _.flatten(list, shallow, output)
  output = output or {}

  _.each(list, function(value)
    if _.is_array(value) then
      if shallow then
        _.each(value, function(v) table.insert(output, v) end)
      else
        _.flatten(value, false, output)
      end
    else
      table.insert(output, value)
    end
  end)

  return output
end

function _.without(list, ...)
  local args = {...}

  return _.difference(list, args)
end

function _.uniq(list, sorted, iterator)
  local initial, results, seen = list, {}, {}
  if iterator then
    initial = _.map(list, iterator)
  end

  _.each(initial, function(value, index)
    if (sorted and (index==1 or seen[#seen]~=value)) or (not _.contains(seen, value)) then
      table.insert(seen, value)
      table.insert(results, list[index])
    end
  end)

  return results
end

function _.index_of(list, value, start)
  if not list then return 0 end
  start = start or 1

  for index = start, #list, 1 do
    if value == list[index] then
      return index
    end
  end

  return 0
end

function _.intersection(a, ...)
  local b = {...}
  return _.filter(_.uniq(a), function(item)
    return _.every(b, function(other)
      return _.index_of(other, item) >= 1
    end)
  end)
end

function _.union(...)
  return _.uniq(_.flatten({...}, true))
end

function _.difference(a, ...)
  local b = _.flatten({...}, true)
  return _.filter(a, function(value)
    return not _.contains(b, value)
  end)
end

function _.zip(...)
  local args = {...}
  local length = _.max(_.map(args, function(a) return #a end))
  local results = {}

  for i=1, length, 1 do
    table.insert(results, _.pluck(args, i))
  end

  return results
end

function _.object(list, values)
  if not list then return {} end
  
  local result = {}
  _.each(list, function(value, index)
    if values then
      result[value] = values[index]
    else
      result[value[1]] = value[2]
    end
  end)

  return result
end

function _.last_index_of(list, value, start)
  if not list then return 0 end
  start = start or #list

  for index = start, 1, -1 do
    if value == list[index] then
      return index
    end
  end

  return 0
end

function _.keys(list)
  if not _.is_object(list) then error("Not an object") end
  return _.map(list, function(_, key)
    return key
  end)
end

function _.values(list)
  if _.is_array(list) then return list end
  return _.map(list, function(value)
    return value
  end)
end

function _.pairs(list)
  return _.map(list, function(value, key)
    return {key, value}
  end)
end

function _.invert(list)
  local array = {}

  _.each(list, function(value, key)
    array[value] = key
  end)

  return array
end

function _.functions(list)
  local method_names = {}

  _.each(list, function(value, key)
    if _.is_function(value) then
      table.insert(method_names, key)
    end
  end)

  return method_names
end

function _.extend(list, ...)
  local lists = {...}
  _.each(lists, function(source)
    _.each(source, function(value, key)
      list[key] = source[key]
    end)
  end)

  return list
end

function _.pick(list, ...)
  local keys = _.flatten({...})

  local array = {}
  _.each(keys, function(key)
    if list[key] then
      array[key] = list[key]
    end
  end)

  return array
end

function _.omit(list, ...)
  local keys = _.flatten({...})

  local array = {}
  _.each(list, function(value,key)
    if not _.contains(keys, key) then
      array[key] = list[key]
    end
  end)

  return array
end

function _.defaults(list, ...)
  local keys = {...}

  _.each(keys, function(source)
    _.each(source, function(value, key)
      if not list[key] then
        list[key] = value
      end
    end)
  end)

  return list
end

function _.clone(list)
  if not _.is_object(list) then return list end

  if _.is_array(list) then
    return slice(list, 1, #list) 
  else
    return _.extend({}, list)
  end
end

function _.is_nan(value)
  return _.is_number(value) and value ~= value 
end

function _.is_empty(value)
  if not value then
    return true
  elseif _.is_array(value) or _.is_object(value) then
    return next(value) == nil
  elseif _.is_string(value) then
    return string.len(value) == 0
  else
    return false
  end
end

function _.is_object(value)
  return type(value) == "function" or type(value) == "table"
end

function _.is_array(value)
  return _.is_object(value) and value[1]
end

function _.is_string(value)
  return type(value) == "string"
end

function _.is_number(value)
  return type(value) == "number"
end

function _.is_function(value)
  return type(value) == "function"
end

function _.is_finite(value)
  return _.is_number(value) and -math.huge < value and value < math.huge
end

function _.is_boolean(value)
  return type(value) == "boolean"
end

function _.is_nil(value)
  return value == nil
end

function _.tap(value, func)
  func(value)
  return value
end

function _.split(value)
  if _.is_string(value) then
    local values = {}
    string.gsub(value, "[^%s+]", function(c)
      table.insert(values, c)
    end)

    return values
  else
    return {}
  end
end

function _.print_r (t, name, indent)
  local tableList = {}
  function table_r (t, name, indent, full)
    local serial=string.len(full) == 0 and name
        or type(name)~="number" and '["'..tostring(name)..'"]' or '['..name..']'
    io.write(indent,serial,' = ') 
    if type(t) == "table" then
      if tableList[t] ~= nil then io.write('{}; -- ',tableList[t],' (self reference)\n')
      else
        tableList[t]=full..serial
        if next(t) then -- Table not empty
          io.write('{\n')
          for key,value in pairs(t) do table_r(value,key,indent..'\t',full..serial) end 
          io.write(indent,'};\n')
        else io.write('{};\n') end
      end
    else io.write(type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"'
                  or tostring(t),';\n') end
  end
  table_r(t,name or '__unnamed__',indent or '','')
end

_.collect = _.map
_.inject = _.reduce
_.foldl = _.reduce
_.foldr = _.reduceRight
_.detect = _.find
_.filter = _.select
_.every = _.all
_.same = _.any
_.contains = _.include
_.head = _.first
_.take = _.first
_.drop = _.rest
_.tail = _.rest

return _
