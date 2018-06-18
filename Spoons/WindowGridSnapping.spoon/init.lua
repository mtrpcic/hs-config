-- Spoon Container Object
local obj = {}
obj.__index = obj

-- Spoon Metadata
obj.name = "WindowGradSnapping"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.grid = {
    rows = 4,
    columns = 6,
    margins = 1
}

-- Hotkey Definition (All keys inherit hyper)
obj.hotkeys = {
    primary = {
        left  = "flexLeft",
        right = "flexRight",
        up    = "flexUp",
        down  = "flexDown",
        M     = "maximize",
        S     = "snap"
    },

    secondary = {
        left  = "moveLeft",
        right = "moveRight",
        up    = "moveUp",
        down  = "moveDown"
    }
}

-- Utility Methods
function getActiveWindow()
    return hs.application.frontmostApplication():focusedWindow()    
end

function obj:windowAtTop(win)
    local cell = hs.grid.get(win)
    return cell.y == 0
end

function obj:windowAtBottom(win)
    local cell = hs.grid.get(win)
    return (cell.y + cell.h) == self.grid.rows
end

function obj:windowAtLeft(win)
    local cell = hs.grid.get(win)
    return cell.x == 0
end

function obj:windowAtRight(win)
    local cell = hs.grid.get(win)
    return (cell.x + cell.w) == self.grid.columns
end

-- Spoon Methods
function obj:bindHotkeys(hyper)
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

function obj:maximize()
    hs.window.maximize(getActiveWindow())
end

function obj.snap()
    hs.grid.snap(getActiveWindow())
end

function obj:flexLeft()
    local win = getActiveWindow()
    if self:windowAtLeft(win) then
        hs.grid.resizeWindowThinner(win)
    else
        self:moveLeft()
        hs.grid.resizeWindowWider(win)
    end
end

function obj:flexRight()
    local win = getActiveWindow()
    if self:windowAtRight(win) then
        hs.grid.resizeWindowThinner(win)
        self:moveRight()
    else
        hs.grid.resizeWindowWider(win)
    end
end

function obj:flexUp()
    local win = getActiveWindow()
    if self:windowAtTop(win) then
        hs.grid.resizeWindowShorter(win)
    else
        self:moveUp()
        hs.grid.resizeWindowTaller(win)
    end
end

function obj:flexDown()
    local win = getActiveWindow()
    if self:windowAtBottom(win) then
        print("At the bottom")
        hs.grid.resizeWindowShorter(win)
        self:moveDown()
    else
        hs.grid.resizeWindowTaller(win)
    end
end

function obj:moveLeft()
    hs.grid.pushWindowLeft(getActiveWindow())
end

function obj:moveRight()
    hs.grid.pushWindowRight(getActiveWindow())
end

function obj:moveUp()
    hs.grid.pushWindowUp(getActiveWindow())
end

function obj:moveDown()
    hs.grid.pushWindowDown(getActiveWindow())
end

function obj:start()
    hs.grid.setGrid(self.grid.columns .. "x" .. self.grid.rows)
    hs.grid.setMargins(self.grid.margins .. "x" ..self.grid.margins)
    hs.window.animationDuration = 0
end

return obj