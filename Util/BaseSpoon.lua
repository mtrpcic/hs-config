-- Base Spoon
-- ----------
-- This is a base spoon class that should be used for all custom internal spoons. It defines
-- the default hotkey and mouse event binding system, as well as some useful and required
-- methods that all internal spoons will extend.

local BaseSpoon = {}
-- BaseSpoon.__index = BaseSpoon
BaseSpoon_mt = { __index = BaseSpoon }


-- Default Metadata fields
BaseSpoon.name = nil
BaseSpoon.version = nil
BaseSpoon.author = nil

-- Default Hotkey Container
BaseSpoon.hotkeys = {
    primary = {},
    secondary = {}
}

-- Default MouseEvent Container
BaseSpoon.mouseEvents = {}

-- The default hotkey mapping function. This method reads the `hotkeys` table on this object
-- and binds them appropriately.
-- @param hyper A table containing the primary and secondary hyper configs
function BaseSpoon:bindHotkeys(hyper)
    local hyper_types = {"primary", "secondary"}
    local def = {}
    local map = {}

    for i, type in ipairs(hyper_types) do
        for key, name in pairs(self.hotkeys[type]) do
            map[name] = { hyper[type], key}
            local dispatch = function()
                return self[name](self)
            end

            def[name] = dispatch
        end
    end

    hs.spoons.bindHotkeysToSpec(def, map)
end

-- The default MouseEvent binding method. This method will read the internal mouseEvents table
-- of this object and bind all events.
function BaseSpoon:bindMouseEvents()
    for event_name, method_name in pairs(self.mouseEvents) do
        local dispatch = function()
            return self[method_name](self)
        end
        local event = hs.eventtap.new({hs.eventtap.event.types[event_name]}, dispatch)
        table.insert(self.activeEvents, event)
        event:start()
    end
end

-- Required methods for all spoons. Spoons don't need to override these, but all spoons must contain
-- these three methods, so the base class provides them.
function BaseSpoon:start() end
function BaseSpoon:stop() end
function BaseSpoon:init() end

-- Extend method that all "sub spoons" must call to create their base instance.
function BaseSpoon:new()
    local subSpoon = {}
    setmetatable( subSpoon, BaseSpoon_mt )
    return subSpoon 
end

return BaseSpoon;