-- Window Utils
-- ------------
-- This module provides utility methods that are meant to be used in conjuction with the hs.window
-- module. Methods in this module can be used by multiple window related spoons without code
-- duplication.

-- Load Dependencies
local Point = require "Util/Point"

-- Window Util Container Object
local Window = {}

-- Map of functions that accept a window frame and a screen frame, and determine if the window is at the keyed cardinality
-- within a specified margin
Window.isAtMap = {
    top    = function(w, f, m) return Point.isAtTop(w, f, m) end,
    bottom = function(w, f, m) return Point.isAtBottom(hs.geometry.new({x = w.x, y = w.y + w.h}), f, m) end,
    left   = function(w, f, m) return Point.isAtLeft(w, f, m) end,
    right  = function(w, f, m) return Point.isAtRight(hs.geometry.new({x = w.x - f.x + w.w, y = w.y}), f, m) end
}

-- Returns the active window
function Window.getActiveWindow()
    return hs.application.frontmostApplication():focusedWindow()
end

-- Given a window, makes it take up the full screen
function Window.maximize(win)
    hs.window.maximize(win)
end

-- Generic method that checks the provided args against the isAtMap
function Window.isAt(win, margin, spot)
    return Window.isAtMap[spot](win:frame(), win:screen():frame(), margin)
end

-- Named methods for specifity edge checking
function Window.isAtTop(win, withinMargin)
    return Window.isAt(win, withinMargin, "top")
end

function Window.isAtBottom(win, withinMargin)
    return Window.isAt(win, withinMargin, "bottom")
end

function Window.isAtLeft(win, withinMargin)
    return Window.isAt(win, withinMargin, "left")
end

function Window.isAtRight(win, withinMargin)
    return Window.isAt(win, withinMargin, "right")
end

-- Ensure the window is fully on the screen
function Window.ensureOnScreen(win)
    if not win:frame():inside(win:screen():frame()) then
        win:moveToScreen(win:screen(), true, true)
    end
end

-- Determines if the given window is currently being dragged by comparing the current window
-- state to a previous mouse position state (e.g. if the mouse is dragging, and the mouse is staying)
-- in the same position within the window frame, the window must be dragging as well)
function Window.isBeingDragged(win, compare)

end

return Window