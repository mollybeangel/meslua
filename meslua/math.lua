local math_x = {}

local atan2 = rawget(math,"atan2") or math.atan

function math_x.lerp(x, y, a)
    if x == y then return x end
    if a == 0 then return x end
    if a == 1 then return y end

    return x + (y - x) * a
end

function math_x.inverse_lerp(a, b, value)
    return (value - a) / (b - a)
end

function math_x.clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function math_x.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

function math_x.trunc(x)
    return x < 0 and math.ceil(x) or math.floor(x)
end

function math_x.to_hex(n,include_prefix)
    local hex = string.format("%X", n)
    include_prefix = include_prefix == nil and true or include_prefix
    return include_prefix and "0x" .. hex or hex
end

function math_x.hex_to_rgb(hex)
    assert(type(hex) == "string", "Expected string for hex_to_rgb")

    hex = hex:gsub("^#", "")
    hex = hex:gsub("^0[xX]", "")

    assert(#hex == 6, "Expected a 6-digit hex color")

    return
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
end

function math_x.rgb_to_hex(r, g, b)
    return string.format("%02X%02X%02X", r, g, b)
end

function math_x.from_hex(hex)
    assert(type(hex) == "string", "Expected string for from_hex")
    hex = hex:gsub("^0[xX]", "")
    return tonumber(hex, 16)
end

function math_x.remap(x, old_min, old_max, new_min, new_max)
    local t = (x - old_min) / (old_max - old_min)
    return new_min + t * (new_max - new_min)
end

function math_x.snap(x, step)
    return math.floor(x / step + 0.5) * step
end

function math_x.wrap(x, min, max)
    local range = max - min

    return ((x - min) % range + range) % range + min
end

function math_x.round(x)
    return math.floor(x + 0.5)
end

function math_x.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    return math.sqrt(dx * dx + dy * dy)
end

function math_x.distance3d(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1

    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function math_x.angle(x1, y1, x2, y2)
    return atan2(y2 - y1, x2 - x1)
end

return math_x
