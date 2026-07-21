local mlib = {}

local cwd = (...):gsub('%.init$', '') .. "."

mlib.table = require(cwd .. "table")
mlib.string = require(cwd .. "string")
mlib.math = require(cwd .. "math")
mlib.functional  = require(cwd .. "functional")

return mlib
