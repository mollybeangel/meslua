local math_x = {}

function math_x.lerp(x,y,a)
    if x == y then return x end
    if a == 0 then return x end
    if a == 1 then return y end

    return x + (y - x) * a
end

function math_x.clamp(v, min, max)
    return math.min(math.max(v, min), max)
end

function math_x.trunc(x)
    return x < 0 and math.ceil(x) or math.floor(x)
end

return math_x
