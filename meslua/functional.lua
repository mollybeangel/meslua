local functional = {}

local ipairs = ipairs

function functional.once(fn)
    local c = false
    local r = nil

    return function(...)
        if not c then
            r = fn(...)
            c = true
        end
        return r
    end
end

function functional.compose(...)
    local funcs = {...}

    return function(value)
        for i = #funcs, 1, -1 do
            value = funcs[i](value)
        end

        return value
    end
end

function functional.partial(fn, ...)
    local args = { ... }

    return function(...)
        local new_args = {}

        for _, v in ipairs(args) do
            new_args[#new_args + 1] = v
        end

        for _, v in ipairs({ ... }) do
            new_args[#new_args + 1] = v
        end

        return fn(table.unpack(new_args))
    end
end

function functional.memoize(fn)
    local cache = {}

    return function(...)
        local key = table.concat({ ... }, "|")

        if cache[key] then
            return cache[key]
        end

        local result = fn(...)
        cache[key] = result

        return result
    end
end

function functional.pipe(value, ...)
    local funcs = {...}

    for _, fn in ipairs(funcs) do
        value = fn(value)
    end

    return value
end

return functional
