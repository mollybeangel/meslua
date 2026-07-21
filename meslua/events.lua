local EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter.new()
    return setmetatable({
        events = {}
    }, EventEmitter)
end

function EventEmitter:subscribe(event, callback)
    if not self.events[event] then
        self.events[event] = {}
    end

    table.insert(self.events[event], callback)

    return callback
end

function EventEmitter:emit(event, ...)
    local listeners = self.events[event]

    if not listeners then
        return
    end

    for _, callback in ipairs(listeners) do
        callback(...)
    end
end

function EventEmitter:once(event, callback)
    local wrapper

    wrapper = function(...)
        self:unsubscribe(event, wrapper)
        callback(...)
    end

    self:subscribe(event, wrapper)
end

function EventEmitter:unsubscribe(event, callback)
    local listeners = self.events[event]

    if not listeners then
        return
    end

    for i, listener in ipairs(listeners) do
        if listener == callback then
            table.remove(listeners, i)
            break
        end
    end
end

function EventEmitter:clear(event)
    if event then
        self.events[event] = nil
    else
        self.events = {}
    end
end

function EventEmitter:listeners(event)
    return self.events[event] or {}
end

return EventEmitter
