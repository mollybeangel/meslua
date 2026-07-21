local table_x = {}

local next = next
local pairs = pairs

function table_x.contains(t, what)
    for i = 1, #t do
        if t[i] == what then return true end
    end

    return false
end

function table_x.binary_search(t, what)
    local low, high = 1, #t

    while low <= high do
        local mid = math.floor((low + high) / 2)

        if t[mid] == what then
            return true
        elseif t[mid] < what then
            low = mid + 1
        else
            high = mid - 1
        end
    end

    return false
end

function table_x.is_array(t)
    local n = #t
    local count = 0

    for k in pairs(t) do
        if type(k) ~= "number" or k % 1 ~= 0 or k < 1 or k > n then
            return false
        end
        count = count + 1
    end

    return count == n
end

function table_x.pretty(value, indent)
    indent = indent or 0

    local value_type = type(value)

    if value_type ~= "table" then
        return string.format("%q", value)
    end

    local spaces = string.rep("    ", indent)
    local child_spaces = string.rep("    ", indent + 1)

    local result = "{\n"
    local array = table_x.is_array(value)

    for k, v in pairs(value) do
        result = result .. child_spaces

        if not array then
            result = result .. "[" .. tostring(k) .. "] = "
        end

        result = result .. table_x.pretty(v, indent + 1) .. ",\n"
    end

    result = result .. spaces .. "}"

    return result
end

function table_x.print(t)
    assert(type(t) == "table", "Expected table for table.print")
    print(table_x.pretty(t))
end

function table_x.filter(t, fn)
    local nt = {}

    for i = 1, #t do
        local v = t[i]

        if fn(v, i) then
            nt[#nt + 1] = v
        end
    end

    return nt
end

function table_x.map(t, fn)
    local nt = {}

    for i = 1, #t do
        nt[#nt + 1] = fn(t[i], i)
    end

    return nt
end

function table_x.every(t, fn)
    for i = 1, #t do
        if not fn(t[i], i) then
            return false
        end
    end

    return true
end

function table_x.some(t, fn)
    for i = 1, #t do
        if fn(t[i], i) then
            return true
        end
    end

    return false
end

function table_x.reduce(t, fn, initial)
    local accumulator = initial

    for i = 1, #t do
        accumulator = fn(accumulator, t[i], i)
    end

    return accumulator
end

function table_x.values(t)
    local new_t = {}

    for k, v in next, t do
        table.insert(new_t, v)
    end

    return new_t
end

function table_x.keys(t)
    local new_t = {}

    for k, v in next, t do
        table.insert(new_t, k)
    end

    return new_t
end

function table_x.count(t)
    local c = 0

    for _ in next, t do
        c = c + 1
    end

    return c
end

function table_x.copy(t, should_preserve_mt)
    should_preserve_mt = should_preserve_mt == nil and true or should_preserve_mt

    local copy = {}

    for k, v in next, t do
        copy[k] = v
    end

    if should_preserve_mt then
        return setmetatable(copy, getmetatable(t))
    else
        return copy
    end
end

local function deepcopy_impl(value, seen, should_preserve)
    if type(value) ~= "table" then
        return value
    end

    seen = seen or {}

    if seen[value] then
        return seen[value]
    end

    local copy = {}
    seen[value] = copy

    for k, v in next, value do
        copy[deepcopy_impl(k, seen)] = deepcopy_impl(v, seen)
    end

    if should_preserve then
        return setmetatable(copy, getmetatable(value))
    else
        return copy
    end
end

function table_x.deep_copy(t, should_preserve_mt)
    should_preserve_mt = should_preserve_mt == nil and true or should_preserve_mt
    return deepcopy_impl(t, nil, should_preserve_mt)
end

function table_x.merge(t1, t2, opts)
    local result = table_x.copy(t1)

    if opts ~= nil then
        assert(type(opts) == "table", "Expected opts to be a table for table.merge")
    end

    for k, v in next, t2 do
        if t1[k] and t2[k] and type(v) == "number" and opts and opts.add_numbers then
            result[k] = t1[k] + v
        else
            result[k] = v
        end
     end

     return result
end

function table_x.equals(a, b)
    if a == b then
        return true
    end

    for k, v in next, a do
        if b[k] ~= v then
            return false
        end
    end

    for k in next, b do
        if a[k] == nil then
            return false
        end
    end

    return true
end

local function deep_equals_impl(a, b, seen)
    if a == b then
        return true
    end

    if type(a) ~= type(b) then
        return false
    end

    if type(a) ~= "table" then
        return a == b
    end

    seen = seen or {}

    if seen[a] == b then
        return true
    end

    seen[a] = b

    for k, v in next, a do
        if not deep_equals_impl(v, b[k], seen) then
            return false
        end
    end

    for k in next, b do
        if a[k] == nil then
            return false
        end
    end

    return getmetatable(a) == getmetatable(b)
end

function table_x.deep_equals(a, b)
    return deep_equals_impl(a,b,nil)
end

return table_x
