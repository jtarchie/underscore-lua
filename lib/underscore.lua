local table, ipairs, pairs, math, string = table, ipairs, pairs, math, string

local _ = {}
local chainable_mt = {}

_.identity = function(value) return value end

function _.reverse(list)
  if _.isString(list) then
    return _(list).chain():split():reverse():join():value()
  else
    local length = _.size(list)
    for i = 1, length / 2, 1 do
      list[i], list[length-i+1] = list[length-i+1], list[i]
    end
    return list
  end
end

function _.splice(list, index, howMany, ...)
  if not _.isArray(list) then return nil end

  local elements = {...}
  local removed = {}

  howMany = howMany or #list - index + 1

  for i = 1, #elements, 1 do
    table.insert(list, i + index + howMany - 1, elements[i])
  end

  for i = index, index + howMany - 1, 1 do
    table.insert(removed, table.remove(list, index))
  end
  
  return removed
end

function _.pop(list)
  return table.remove(list, #list)
end

function _.push(list, ...)
  local values = {...}
  _.each(values, function(v)
    table.insert(list, v)
  end)
  return list
end

function _.shift(list)
  return table.remove(list, 1)
end

function _.unshift(list, ...)
  local values = {...}
  _.each(_.reverse(values), function(v)
    table.insert(list, 1, v)
  end)

  return list
end

function _.sort(list, func)
  func = func or function(a,b)
    return tostring(a) < tostring(b)
  end

  table.sort(list, func)
  return list
end

function _.join(list, separator)
  separator = separator or ""
  return table.concat(list,separator) 
end

function _.slice(list, start, stop)
  local array = {}
  stop = stop or #list

  for index = start, stop, 1 do
    table.insert(array, list[index])
  end

  return array
end

function _.concat(...)
  local values = _.flatten({...}, true)
  local cloned = {}

  _.each(values, function(v)
    table.insert(cloned, v)
  end)

  return cloned
end

function _.each(list, func)
  local pairing = pairs
  if _.isArray(list) then pairing = ipairs end

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
  _.each(list, function(value, key, object)
    if init then
      memo = value
      init = false
    else
      memo = func(memo, value, key, object)
    end
  end)

  if init then
    error("Reduce of empty array with no initial value")
  end

  return memo
end

function _.reduceRight(list, func, memo)
  local init = memo == nil
  _.each(_.reverse(list), function(value, key, object)
    if init then
      memo = value
      init = false
    else
      memo = func(memo, value, key, object)
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
  _.any(list, function(value, key, object)
    if func(value, key, object) then
      result = value
      return true
    end
  end)

  return result 
end

function _.select(list, func)
  local found = {}
  _.each(list, function(value, key, object)
    if func(value, key, object) then
      table.insert(found, value)
    end
  end)

  return found
end

function _.reject(list, func)
  local found = {}
  _.each(list, function(value, key, object)
    if not func(value, key, object) then
      table.insert(found, value)
    end
  end)

  return found
end

function _.all(list, func)
  if _.isEmpty(list) then return false end

  func = func or _.identity

  local found = true
  _.each(list, function(value, index, object)
    if found and not func(value, index, object) then
      found = false
    end
  end)

  return found
end

function _.any(list, func)
  if _.isEmpty(list) then return false end

  func = func or _.identity

  local found = false
  _.each(list, function(value, index, object)
    if not found and func(value, index, object) then
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

function _.findWhere(list, properties)
  return _.first(
    _.where(list, properties)
  )
end

function _.max(list, func)
  if _.isEmpty(list) then
    return -math.huge
  elseif _.isFunction(func) then
    local max = {computed=-math.huge}
    _.each(list, function(value, key, object)
      local computed = func(value, key, object)
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
  if _.isEmpty(list) then
    return math.huge
  elseif _.isFunction(func) then
    local min = {computed=math.huge}
    _.each(list, function(value, key, object)
      local computed = func(value, key, object)
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
  
  if _.isString(func) then
    invoke_func = function(value)
      return value[func](value, unpack(args))
    end
  end

  return _.collect(list, function(value)
    return invoke_func(value, unpack(args))
  end)
end

function _.sortBy(list, func)
  func = func or _.identity
  local sorted_func = function(a,b)
    if a == nil then return false end
    if b == nil then return true end
    return func(a) < func(b)
  end

  if _.isString(func) then
    sorted_func = function(a,b)
      return a[func](a) < b[func](b)
    end
  end

  table.sort(list, sorted_func)
  return list
end

function _.groupBy(list, func)
  local group_func, result = func, {}

  if _.isString(func) then
    group_func = function(v)
      return v[func](v)
    end
  end

  _.each(list, function(value, key, object)
    local key = group_func(value, key, object)
    result[key] = result[key] or {}
    table.insert(result[key], value)
  end)

  return result
end

function _.countBy(list, func)
  local count_func, result = func, {}

  if _.isString(func) then
    count_func = function(v)
      return v[func](v)
    end
  end

  _.each(list, function(value, key, object)
    local key = count_func(value, key, object)
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

function _.toArray(list, ...)
  if not list then return {} end
  if not _.isObject(list) then list = {list, ...} end
  
  local cloned = {}
  _.each(list, function(value)
    table.insert(cloned, value)
  end)

  return cloned
end

function _.size(list, ...)
  local args = {...}

  if _.isArray(list) then
    return #list
  elseif _.isObject(list) then
    local length = 0
    _.each(list, function() length = length + 1 end)
    return length
  elseif _.isString(list) then
    return string.len(list)
  elseif not _.isEmpty(args) then
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

function _.bind(func, context, ...)
  local arguments = {...}
  return function(...)
    return func(context, unpack(_.concat(arguments, {...})))
  end
end

function _.partial(func, ...)
  local args = {...}
  return function(self, ...)
    return func(self, unpack(_.concat(args, {...})))
  end
end

function _.wrap(func, wrapper)
  return function(...)
    return wrapper(func, ...)
  end
end

function _.compose(...)
  local funcs = {...}

  return function(...)
    local args = {...}

    _.each(_.reverse(funcs), function(func)
      args = {func(unpack(args))}
    end)

    return args[1]
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

  if not count then
    return list[1]
  else
    return _.slice(list, 1, count)
  end
end

function _.rest(list, start)
  start = start or 2

  return _.slice(list, start, #list)
end

function _.initial(list, stop)
  stop = stop or (#list - 1)

  return _.slice(list, 1, stop)
end

function _.last(list, count)
  if not list then return nil end

  if not count then
    return list[#list]
  else
    local start, stop, array = #list - count + 1, #list, {}
    return _.slice(list, start, stop)
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
    if _.isArray(value) then
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

function _.indexOf(list, value, start)
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
      return _.indexOf(other, item) >= 1
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

function _.lastIndexOf(list, value, start)
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
  if not _.isObject(list) then error("Not an object") end
  return _.map(list, function(_, key)
    return key
  end)
end

function _.values(list)
  if _.isArray(list) then return list end
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
    if _.isFunction(value) then
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
  if not _.isObject(list) then return list end

  if _.isArray(list) then
    return _.slice(list, 1, #list) 
  else
    return _.extend({}, list)
  end
end

function _.isNaN(value)
  return _.isNumber(value) and value ~= value 
end

function _.isEmpty(value)
  if not value then
    return true
  elseif _.isArray(value) or _.isObject(value) then
    return next(value) == nil
  elseif _.isString(value) then
    return string.len(value) == 0
  else
    return false
  end
end

function _.isObject(value)
  return type(value) == "table"
end

function _.isArray(value)
  return type(value) == "table" and (value[1] or next(value) == nil)
end

function _.isString(value)
  return type(value) == "string"
end

function _.isNumber(value)
  return type(value) == "number"
end

function _.isFunction(value)
  return type(value) == "function"
end

function _.isFinite(value)
  return _.isNumber(value) and -math.huge < value and value < math.huge
end

function _.isBoolean(value)
  return type(value) == "boolean"
end

function _.isNil(value)
  return value == nil
end

function _.tap(value, func)
  func(value)
  return value
end

function splitIterator(value, pattern, start)
  if pattern then
    return string.find(value, pattern, start)
  else
    if start > string.len(value) then
      return nil
    else
      return start+1, start
    end
  end
end
      

function _.split(value, pattern)
  if not _.isString(value) then return {} end
  local values = {}
  local start = 1
  local start_pattern, end_pattern = splitIterator(value, pattern, start)
  
  while start_pattern do
    table.insert(
      values,
      string.sub(value, start, start_pattern - 1)
    )
    start = end_pattern + 1
    start_pattern, end_pattern = splitIterator(value, pattern, start)
  end

  if start <= string.len(value) then
    table.insert(values, string.sub(value, start))
  end
    
  return values
end

function _.capitalize(str)
  str = tostring(str or "")
  return str:gsub("^%l", string.upper)
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function _.numberFormat(number, dec, dsep, tsep)
  if not _.isNumber(number) then return "" end
  dec = dec or 0
  dsep = dsep or '.'

  number = tostring(round(number, dec))
  tsep = tsep or ','

  local parts = _.split(number, '%.')
  local fnums = parts[1]

  local decimals = ''
  if dec and dec > 0 then
    decimals = dsep .. (parts[2] or string.rep('0', dec))
  end
  local digits = fnums:reverse():gsub("(%d%d%d)", '%1' .. tsep):reverse() .. decimals
  if digits:sub(1,1) == tsep then
    return digits:sub(2)
  else
    return digits
  end
end

function _.chain(value)
  return _(value).chain()
end

local id_counter = -1
function _.uniqueId(prefix)
  id_counter = id_counter + 1
  if prefix then
    return prefix .. id_counter
  else
    return id_counter
  end
end

function _.times(n, func)
  for i=0, (n-1), 1 do
    func(i)
  end
end

local result = function(self, obj)
  if _.isObject(self) and self._chain then
    return _(obj).chain()
  else
    return obj
  end
end
  

function _.mixin(obj)
  _.each(_.functions(obj), function(name)
    local func = obj[name]
    _[name] = func

    chainable_mt[name] = function(target, ...)
      local r = func(target._wrapped, ...)
      if _.include({'pop','shift'}, name) then
        return result(target, target._wrapped)
      else
        return result(target, r)
      end
    end
  end)
end

local entityMap = {
  escape={
    ['&']='&amp;',
    ['<']='&lt;',
    ['>']='&gt;',
    ['"']='&quot;',
    ["'"]='&#x27;',
    ['/']='&#x2F;'
  }
}
entityMap.unescape = _.invert(entityMap.escape)

function _.escape(value)
  value = value or ''
  return value:gsub("[" .. _(entityMap.escape).chain():keys():join():value() .. "]", function(s)
    return entityMap['escape'][s]
  end) 
end

function _.unescape(value)
  value = value or ''
  _.each(entityMap.unescape, function(escaped, key)
    value = value:gsub(key, function(s)
      return escaped 
    end) 
  end)

  return value
end

function _.result(obj, prop)
  if not obj then return nil end
  local value = obj[prop]
  
  if _.isFunction(value) then
    return value(obj)
  else
    return value
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
_.methods = _.functions

_.mixin(_)

setmetatable(_,{
  __call = function(target, ...)
    local wrapped = ...
    if _.isObject(wrapped) and wrapped._wrapped then return wrapped end

    local instance = setmetatable({}, {__index=chainable_mt})
    instance.chain = function()
      instance._chain = true
      return instance
    end
    instance.value = function() return instance._wrapped end

    instance._wrapped = wrapped
    return instance
  end
})

return _
