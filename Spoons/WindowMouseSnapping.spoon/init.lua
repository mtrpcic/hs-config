-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local Point     = require "Util/Point"
local Math     = require "Util/Math"

-- Spoon Container Object
local obj = BaseSpoon.new()

-- Spoon Metadata
obj.name = "ConfigReloader"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Hotkey Definition (All keys inherit hyper)
obj.hotkeys = {
    primary = {

    },

    secondary = {
        M = "stop"
    }
}

-- Mouse Event Mapping
obj.mouseEvents = {
    ['leftMouseDragged'] = "onMouseDrag",
    ['leftMouseUp'] = "onMouseUp"
}

-- Internal variables
obj.activeEvents = {}
obj.windowTitlebarHeight = 21
obj.monitorEdgeSensitivity = 5

obj.isCurrentlyDragging = false
obj.currentlyDraggedWindow = nil
obj.currentlyDraggedWindowFrame = nil

-- Method to be called when a mouse drag event
function obj:onMouseDrag()
    if not self.isCurrentlyDragging then
        local win = Window.getActiveWindow()

        if win ~= nil then
            local mouse = hs.mouse.getAbsolutePosition()
            local mouseCoords = hs.geometry.new({x = Math.round(mouse.x), y = Math.round(mouse.y)})
            local winFrame = win:frame()

            if mouseCoords:inside(winFrame) then
                self.isCurrentlyDragging = true
                self.currentlyDraggedWindow = win
                self.currentlyDraggedWindowFrame = winFrame
            end
        end
    end
end

-- Method to be called when the mouse "click" is released. This method is a no-op
-- unless we previously recorded that the mouse was dragging.
function obj:onMouseUp()
    if self.isCurrentlyDragging then
        local mouse = hs.mouse.getAbsolutePosition()
        local mouseCoords = hs.geometry.new({x = Math.round(mouse.x), y = Math.round(mouse.y)})
        local win = Window.getActiveWindow()
        local screenFrame = win:screen():frame()

        if not self.currentlyDraggedWindowFrame:equals(win:frame()) and Point.isAtEdge(mouseCoords, screenFrame, self.monitorEdgeSensitivity) then
            self:applySnap(win, mouseCoords, screenFrame)
        end
    end
    self.isCurrentlyDragging = false
    self.currentlyDraggedWindow = nil
    self.currentMousePositionInWindow = nil
end

-- Apply the snap to the window. This method will calculate the appropriate height, width, and coordinates
-- of window origin and apply them to the window.
function obj:applySnap(win, coords, max)
    local newWinFrame = hs.geometry.copy(max)
    local flag = false

    if Point.isAtTop(coords, max, self.monitorEdgeSensitivity) then
        if Point.isAtLeft(coords, max, self.monitorEdgeSensitivity) or Point.isAtRight(coords, max, self.monitorEdgeSensitivity) then
            newWinFrame.h = Math.round(newWinFrame.h / 2)
        end
        flag = true
    end

    if Point.isAtBottom(coords, max, self.monitorEdgeSensitivity) then
        newWinFrame.h = Math.round(newWinFrame.h / 2) + max.y -- max.y accounds for the MacOS title bar
        newWinFrame.y = newWinFrame.h

        flag = true
    end

    if Point.isAtLeft(coords, max, self.monitorEdgeSensitivity) then
        newWinFrame.w = Math.round(newWinFrame.w / 2)
        flag = true
    end

    if Point.isAtRight(coords, max, self.monitorEdgeSensitivity) then
        newWinFrame.w = Math.round(newWinFrame.w / 2)
        newWinFrame.x = newWinFrame.w
        flag = true
    end

    if flag then
        print("Screen: X = " .. max.x .. ", Y = " .. max.y .. ", H = " .. max.h .. ", W = " .. max.w)
        print("Window: X = " .. newWinFrame.x .. ", Y = " .. newWinFrame.y .. ", H = " .. newWinFrame.h .. ", W = " .. newWinFrame.w)
        --win:setFrameInScreenBounds(newWinFrame)
        win:move(newWinFrame):setSize(newWinFrame):setFrame(newWinFrame)
        --win:setFrameWithWorkarounds(newWinFrame)
    end
end

function obj:start()
    -- For OSX event timing issues, we need to hook in after _some_ animation.
    if hs.window.animationDuration == 0 then
        hs.window.animationDuration = 0.00000001    
    end
end

function obj:stop()
    for index, event in ipairs(self.activeEvents) do
        event:stop()
    end
    self.activeEvents = {}
end

return obj