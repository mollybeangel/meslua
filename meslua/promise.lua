local Promise = {}
Promise.__index = Promise

function Promise.new(executor)
    local self = setmetatable({
        state = "pending",
        executor = executor,
        value = nil,
        handlers = {},
        waiting = {},
        success = {}
    }, Promise)
    return self
end

function Promise:start()
    if self.started then
        return
    end

    self.started = true

    self.executor(function(value)
        self.state = "fulfilled"
        self.value = value
    end)
end

function Promise:await()
    self:start()

    if self.state == "fulfilled" then
        return self.value
    end

    local thread = coroutine.running()

    table.insert(self.waiting, thread)

    return coroutine.yield()
end

function Promise:resolve(value)
    if self.state ~= "pending" then
        return
    end

    self.state = "fulfilled"
    self.value = value

    for _, callback in ipairs(self.success) do
        callback(value)
    end
end

function Promise:reject(err)
    if self.state ~= "pending" then
        return
    end

    self.state = "rejected"
    self.value = err

    for _, callback in ipairs(self.failure) do
        callback(err)
    end
end

function Promise:and_then(callback)
    self:start()

    if self.state == "fulfilled" then
        callback(self.value)
    elseif self.state == "pending" then
        table.insert(self.success, callback)
    end

    return self
end

function Promise:catch(callback)
    if self.state == "rejected" then
        callback(self.value)
    elseif self.state == "pending" then
        table.insert(self.failure, callback)
    end

    return self
end

return Promise
