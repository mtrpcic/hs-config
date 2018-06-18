## Mike's Productivity Booster

### Setup Instructions

1. Install [hammerspoon](https://github.com/Hammerspoon/hammerspoon) by downloading it from the Github Releases, or, if you use Homebrew and Cask, running `brew cask install hammerspoon`
2. Open the Hammerspoon app and follow the instructions to give it appropriate accessibility access
3. **Read all of the code in this repository and make sure you trust it before you execute any of it**
4. Clone this repository into your hammerspoon configuration folder with the command `git clone git@github.com:mtrpcic/hammerspoon-config.git ~/.hammerspoon/`
5. Restart Hammerspoon or reload the config

### Configuration
##### General Options
You can change which Spoons get loaded in `init.lua`. Each spoon has it's own `init.lua` that will outline configuration options for that specific module. If you are going to be editing configurations, I recommend you make a branch beforehand so that you can pull updates into master and merge them against your own customizations. 

#### Modules
Select which modules you want to 

##### Key Binding
You define your main key mapping modifier in `init.lua` (named `hyper`. The dafault configuration is below.

```lua
local hyper = {
    primary = {"cmd", "alt", "ctrl"},
    secondary = {"cmd", "alt", "shift"}
}
```

This will be injected into all of the Spoon modules, so as they define their own key commands, they must only indicate if they are for the primary or secondary modifier.

### Usage

##### Congig Reloading
This Hammerspoon setup will automatically reload the configuration 

|Key Binding|Action|
|---|---|
|primary + R|Manually tell Hammerspoon to reload the config|

##### Window Grid
This config also includes a window grid setup. You can snap windows to the grid, move them around, and resize them all with keyboard shortcuts. These operations always take action on the currently focused window. If that window is unable to be resized (like certain system modals), nothing will happen.

|Key Binding|Action|
|---|---|
|`primary + S`| Snap the current window to the nearest grid cell|
|`primary + M`| Maximize the current window (take up the full screen without going "full screen")|
|`primary + up`| Extend the window up one cell. If the window is at the top of the screen, the bottom will move up.|
|`primary + down`| Extend the window down one cell. If the window is at the bottom of the screen, the top will move down.|
|`primary + left`| Extend the window left one cell. If the window is at the left of the screen, the right will move left.|
|`primary + right`| Extend the window right one cell. If the window is at the right of the screen, the left will move right.|
|`secondary + up`| Move the current active window up one cell|
|`secondary + down`| Move the current active window down one cell|
|`secondary + left`| Move the current active window left one cell|
|`secondary + right`| Move the current active window right one cell|

##### Window Snapping
Sometimes in the heat of the moment, you just jump to the mouse. This config includes mouse-based window snapping. If you drag a window to either side of the screen, 

|Key Binding|Action|
|---|---|
|drag > top| Snap window to full screen |
|drag > top + left| Snap window to 1/4 screen, anchored top left|
|drag > top + right| Snap window to 1/4 screen, achored top right|
|drag > left| Snap window to 1/2 screen, anchored left|
|drag > right| Snap window to 1/2 screen, anchored right|
|drag > bottom + left| Snap window to 1/4 screen, anchored left|
|drag > bottom + right| Snap window to 1/4 screen, anchored right|
|secondary + M| Turn off all mouse handlers for window snapping.<br /> You can turn them back on by reloading the config. |

##### AppLauncher
You can define one-command shortcuts to open any applications here. There are no standard hotkeys, but you can define any hotkey you want (just be careful you don't conflict with one of the defined keys above).

Apps are opened with a "Launch or Focus" directive. If the app is already opened, the most recently focused window will be given focus.

|Key Binding|Action|
|---|---|
|(primary/secondary) + ?| Customize app launcher shortcuts. |


### Pro Tips
1. Download [Karabiner](https://pqrs.org/osx/karabiner/) and set Caps Lock to your primary keybind.

### Notes
I took setting this project up as a challenge to learn and use Lua for something that was actually useful. Please PR any obvious optimizations or glaring Lua issues that I've made along the way.

### Contributing
This is a casual project. Just PR into it and we'll chat. Please stick to standard Hammerspoon conventions, and any/all functionality should be contained within a Spoon.