-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"

-- Spoon Container Object
local obj = BaseSpoon.new()

-- Spoon Metadata
obj.name = "WindowGradSnapping"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.grid = {
    rows = 3,
    columns = 4,
    margins = 0
}

-- Hotkey Definition (All keys inherit hyper)
obj.hotkeys = {
    primary = {
        left  = "flexLeft",
        right = "flexRight",
        up    = "flexUp",
        down  = "flexDown",
        M     = "maximize",
        S     = "snap",
        N     = "nextScreen",
        P     = "prevScreen"
    },

    secondary = {
        left  = "moveLeft",
        right = "moveRight",
        up    = "moveUp",
        down  = "moveDown"
    }
}

-- Spoon Methods

function obj:maximize()
    hs.window.maximize(Window.getActiveWindow())
end

function obj.snap()
    hs.grid.snap(Window.getActiveWindow())
end

function obj:flexLeft()
    local win = Window.getActiveWindow()
    if Window.isAtLeft(win, self.grid.margins) then
        hs.grid.resizeWindowThinner(win)
    else
        self:moveLeft()
        hs.grid.resizeWindowWider(win)
    end
end

function obj:flexRight()
    local win = Window.getActiveWindow()
    if Window.isAtRight(win, self.grid.margins) then
        hs.grid.resizeWindowThinner(win)
        self:moveRight()
    else
        hs.grid.resizeWindowWider(win)
    end
end

function obj:flexUp()
    local win = Window.getActiveWindow()
    if Window.isAtTop(win, self.grid.margins) then
        hs.grid.resizeWindowShorter(win)
    else
        self:moveUp()
        hs.grid.resizeWindowTaller(win)
    end
end

function obj:flexDown()
    local win = Window.getActiveWindow()
    if Window.isAtBottom(win, self.grid.margins) then
        hs.grid.resizeWindowShorter(win)
        self:moveDown()
    else
        hs.grid.resizeWindowTaller(win)
    end
end

function obj:moveLeft()
    hs.grid.pushWindowLeft(Window.getActiveWindow())
end

function obj:moveRight()
    hs.grid.pushWindowRight(Window.getActiveWindow())
end

function obj:moveUp()
    hs.grid.pushWindowUp(Window.getActiveWindow())
end

function obj:moveDown()
    hs.grid.pushWindowDown(Window.getActiveWindow())
end

function obj:nextScreen()
    local win = Window.getActiveWindow()
    win:moveToScreen(win:screen():next())
end

function obj:prevScreen()
    local win = Window.getActiveWindow()
    win:moveToScreen(win:screen():previous())
end

function obj:start()
    hs.grid.setGrid(self.grid.columns .. "x" .. self.grid.rows)
    hs.grid.setMargins(self.grid.margins .. "x" ..self.grid.margins)
    hs.window.animationDuration = 0
end

return obj