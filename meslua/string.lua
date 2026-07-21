local string_x = {}

local DEFAULT_CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

local old_index_fn = nil
local str_literal_mt = nil

function string_x.extend_std()
    str_literal_mt = getmetatable("")

    old_index_fn = str_literal_mt.__index
    str_literal_mt.__index = function(str, key)
        return rawget(string_x, key) or rawget(string, key)
    end

    setmetatable(string, {
        __index = function(self, key)
            return rawget(string_x, key) or rawget(self, key)
        end
    })
end

function string_x.unextend_std()
    if str_literal_mt then
        str_literal_mt.__index = old_index_fn
        setmetatable(string,nil)
    end
end

function string_x.sep_case(s, sep)
    return s:gsub("(%u+)(%u%l)", "%1" .. sep .. "%2"):gsub("(%l%d)(%u)", "%1" .. sep .. "%2"):gsub("[%s_-]+", sep):lower()
end

function string_x.pascal_case(s)
    return (s:gsub("^%l", string.upper):gsub("[_%-%s]+(%l)", string.upper):gsub("[_%-%s]+", ""))
end

function string_x.camel_case(s)
    return (string_x.pascal_case(s):gsub("^%u", string.lower))
end

function string_x.snake_case(s)
    return s:gsub("(%l)(%u)", "%1_%2"):gsub("[%s%-]+", "_"):lower()
end

function string_x.kebab_case(s, should_snakecase)
    s = should_snakecase and string_x.snake_case(s) or s
    return s:gsub("(%u+)(%u%l)", "%1-%2"):gsub("(%l%d)(%u)", "%1-%2"):gsub("[%s_]+", "-"):lower()
end

function string_x.title_case(s)
    return (s:gsub("(%a)([%w_]*)", function(first, rest)
        return first:upper() .. rest:lower()
    end))
end

function string_x.capitalize(s)
    if s == "" then
        return s
    end

    return s:sub(1, 1):upper() .. s:sub(2)
end

function string_x.split(s, sep)
    sep = sep or " "

    local result = {}

    for part in (s .. sep):gmatch("(.-)" .. sep) do
        result[#result + 1] = part
    end

    return result
end

function string_x.random(length, charset)
    charset = charset or DEFAULT_CHARSET

    local output = {}

    for i = 1, length do
        local index = math.random(#charset)
        output[i] = charset:sub(index, index)
    end

    return table.concat(output)
end

function string_x.trim(s)
    return s:match("^%s*(.-)%s*$")
end

function string_x.pad_left(s, width, char)
    char = char or " "

    local padding = width - #s

    if padding <= 0 then
        return s
    end

    return char:rep(padding) .. s
end

function string_x.pad_right(s, width, char)
    char = char or " "

    local padding = width - #s

    if padding <= 0 then
        return s
    end

    return s .. char:rep(padding)
end

function string_x.center(s, width, char)
    char = char or " "

    local padding = width - #s

    if padding <= 0 then
        return s
    end

    local left = math.floor(padding / 2)
    local right = padding - left

    return char:rep(left) .. s .. char:rep(right)
end

function string_x.is_alpha(c)
    return c:match("[a-zA-Z_]") ~= nil
end

function string_x.is_digit_byte(c)
    local b = c:byte()
    return b >= 48 and b <= 57
end

function string_x.is_digit(c)
    return c:match("[0-9]") ~= nil
end

function string_x.is_alpha_numeric(c)
    return string_x.is_alpha(c) or string_x.is_digit(c)
end

function string_x.is_blank(s)
    return s:match("^%s*$") ~= nil
end

function string_x.starts_with(s, prefix)
    return s:sub(1,1) == prefix
end

function string_x.ends_with(s,suffix)
    return s:sub(#s,#s) == suffix
end

return string_x
