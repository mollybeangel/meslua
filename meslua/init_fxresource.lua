local lib_name = "meslua"

if type(...) == "number" then
    _G.meslua = {}

    local function load_module(self, name)
        local chunk = _G["LoadResourceFile"](lib_name, string.format("%s.lua", name))
        assert(chunk, string.format("Failed to load '%s' resource file from %s", name, lib_name))
        local fn, err = load(chunk)

        if not err and fn then
            self[name] = fn()
            return self[name]
        end
    end

    meslua.string = load_module(meslua,"string")
    meslua.table = load_module(meslua,"table")
    meslua.math = load_module(meslua,"math")
    meslua.promise = load_module(meslua,"promise")
    meslua.functional = load_module(meslua,"functional")
    meslua.events = load_module(meslua,"events")

    return meslua
else
    return require((...):gsub('%.init_fxresource$', '') .. "." .. "init")
end
