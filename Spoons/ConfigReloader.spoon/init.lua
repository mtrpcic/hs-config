-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"

-- Spoon Container Object
local obj = BaseSpoon.new()

-- Spoon Metadata
obj.name = "ConfigReloader"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.config_path = hs.configdir

-- Hotkey Definition
obj.hotkeys = {
    primary = {
        R = "reloadConfig"
    },

    secondary = {

    }
}

-- Spoon Locals
obj.watcher = nil

-- Spoon Methods
function obj:bindHotkeys(hyper)
    local hyper_types = {"primary", "secondary"}
    local def = {}
    local map = {}

    for i, type in ipairs(hyper_types) do
        for key, name in pairs(self.hotkeys[type]) do
            map[name] = { hyper[type], key}
            def[name] = self[name]
        end
    end

    hs.spoons.bindHotkeysToSpec(def, map)
end

function obj:reloadConfig()
    hs.reload()
    hs.notify.new({title="Hammerspoon Config Reloaded"}):send()
end

function obj:start()
    local function reload()
        self:reloadConfig()
    end
    self.watcher = hs.pathwatcher.new(self.config_path, self.reloadConfig):start()
end

function obj:stop()
    self.watcher.stop()
end

return obj