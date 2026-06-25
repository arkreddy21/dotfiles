-- See https://wiki.hypr.land/Configuring/Basics/Binds/
-- See https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local mainMod = "SUPER"
local ipc = "noctalia msg"
-- Set programs that you use
local terminal = "kitty"
-- local fileManager = "nautilus /home/arama/Documents/Books/Masters"
local fileManager = "dolphin"
local browser = "zen-browser"
local taskmanager = "kitty -e btop"
-- local menu = "rofi -show drun"
local menu = ipc .. " panel-toggle launcher"

-- ###############################################################################
-- ##! Actions

-- hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
--hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("wlogout -p layer-shell"))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(ipc .. " bar-toggle"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(ipc .. " panel-open session"))
-- hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"))

hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + M", hl.dsp.exit())

hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("voxtype record start"))                    -- copilot key
hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("voxtype record stop"), { release = true }) -- copilot key
hl.bind("SUPER + P", hl.dsp.exec_cmd([[kitty --class hyprmoncfg -e 'hyprmoncfg']]))             -- also display fn key (f9)


hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("SUPER + ALT + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
-- hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd(ipc .. " session lock"))
-- hl.bind("SUPER + ALT + SHIFT + L", hl.dsp.exec_cmd(ipc .. " session lock-and-suspend"))

hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + G", hl.dsp.group.next())
hl.bind(mainMod .. " + ALT + G", hl.dsp.group.prev())

-- Screenshot edit
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]])) -- Screen snip >> edit
-- OCR
hl.bind("CTRL + SHIFT + Print",
    hl.dsp.exec_cmd(
        [[grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"]])) -- Screen snip to text >> clipboard
-- Color picker
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))                                               -- Pick color (Hex) >> clipboard
-- Recording stuff
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh --fullscreen-sound"),
    { description = "Record screen (with sound)" })                                            -- Record screen (with sound)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh --fullscreen"),
    { description = "Record screen (no sound)" })                                              -- Record screen (no sound)
hl.bind(mainMod .. " + SHIFT + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh"),
    { description = "Record region (no sound)" })                                              -- Record region (no sound)
-- Screenshots
-- hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))                                        -- Screenshot a region
hl.bind("Print", hl.dsp.exec_cmd("flameshot gui")) -- Screenshot a region
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))                -- Screenshot a region to clipboard only
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot -m window"))                                -- Screenshot a window
hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))        -- Screenshot a window to clipboard only
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1"))                         -- Screenshot entire screen
hl.bind("ALT + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 --clipboard-only")) -- Screenshot entire screen to clipboard only


-- ##################################################################################
-- #!
-- ##! Window management

--/# bind = Super+Shift, ←/↑/→/↓,, # Window: move in direction
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.swap({ direction = "d" }))

--/# bind = Super, ←/↑/→/↓,, # Focus in direction
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Layout-safe split resize
local function resize_split(delta)
    local win = hl.get_active_window()
    if not win then return end
    local layout = win.workspace.tiled_layout

    if layout == "master" then
        hl.dispatch(hl.dsp.layout("mfact " .. delta))
    elseif layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("splitratio " .. delta))
    elseif layout == "scrolling" then
        hl.dispatch(hl.dsp.layout("colresize " .. delta))
    end
end
hl.bind(mainMod .. " + Semicolon", function() resize_split("-0.1") end, { repeating = true })
hl.bind(mainMod .. " + Apostrophe", function() resize_split("+0.1") end, { repeating = true })

-- Layout-safe toggle split / swap with master
local function toggle_split()
    local win = hl.get_active_window()
    if not win then return end
    local layout = win.workspace.tiled_layout
    if layout == "master" then
        hl.dispatch(hl.dsp.layout("swapwithmaster"))
    elseif layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("togglesplit"))
    elseif layout == "scrolling" then
        hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
    end
end
hl.bind(mainMod .. " + B", function() toggle_split() end)


-- Positioning mode
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized" })) -- maximize
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float())
hl.bind(mainMod .. " + ALT+ P", hl.dsp.window.pin())                         -- Pin
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

--!
-- ##! Workspace management

-- special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }))

hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("work"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:work", follow = true }))


-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))

hl.bind(mainMod .. " + ALT + 1", hl.dsp.focus({ workspace = "11" }))
hl.bind(mainMod .. " + ALT + 2", hl.dsp.focus({ workspace = "12" }))
hl.bind(mainMod .. " + ALT + 3", hl.dsp.focus({ workspace = "13" }))
hl.bind(mainMod .. " + ALT + 4", hl.dsp.focus({ workspace = "14" }))
hl.bind(mainMod .. " + ALT + 5", hl.dsp.focus({ workspace = "15" }))
hl.bind(mainMod .. " + ALT + 6", hl.dsp.focus({ workspace = "16" }))
hl.bind(mainMod .. " + ALT + 7", hl.dsp.focus({ workspace = "17" }))
hl.bind(mainMod .. " + ALT + 8", hl.dsp.focus({ workspace = "18" }))
hl.bind(mainMod .. " + ALT + 9", hl.dsp.focus({ workspace = "19" }))
hl.bind(mainMod .. " + ALT + 0", hl.dsp.focus({ workspace = "20" }))

--/# bind = Super+Shift, Hash,, # Window: move to workspace # (1, 2, 3, 4, ...) and focus
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }))

hl.bind(mainMod .. " + ALT + SHIFT + 1", hl.dsp.window.move({ workspace = "11", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 2", hl.dsp.window.move({ workspace = "12", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 3", hl.dsp.window.move({ workspace = "13", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 4", hl.dsp.window.move({ workspace = "14", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 5", hl.dsp.window.move({ workspace = "15", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 6", hl.dsp.window.move({ workspace = "16", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 7", hl.dsp.window.move({ workspace = "17", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 8", hl.dsp.window.move({ workspace = "18", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 9", hl.dsp.window.move({ workspace = "19", follow = true }))
hl.bind(mainMod .. " + ALT + SHIFT + 0", hl.dsp.window.move({ workspace = "20", follow = true }))

--/# bind = Super+Alt, Hash,, # Window: move to workspace # (1, 2, 3, 4, ...)
hl.bind(mainMod .. " + CTRL + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = false }))
hl.bind(mainMod .. " + CTRL + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = false }))

--/# bind = Super, Page_↑/↓,, # Workspace: focus left/right
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "r-1" }))

--/# bind = Super+Shift, Page_↑/↓,, # Window: move to workspace left/right
hl.bind(mainMod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "r+1", follow = true }))
hl.bind(mainMod .. " + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "r-1", follow = true }))
hl.bind(mainMod .. " + ALT + Page_Down", hl.dsp.window.move({ workspace = "r+1", follow = false }))
hl.bind(mainMod .. " + ALT + Page_Up", hl.dsp.window.move({ workspace = "r-1", follow = false }))

-- ###### Extra binds ############################################
-- hl.bind("CTRL + SUPER + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1", follow = true }))
-- hl.bind("CTRL + SUPER + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1", follow = true }))
-- hl.bind("CTRL + SUPER + BracketLeft", hl.dsp.focus({ workspace = "r-1" }))
-- hl.bind("CTRL + SUPER + BracketRight", hl.dsp.focus({ workspace = "r+1" }))

--/# bind = Super+Shift, Scroll ↑/↓,, # Window: move to workspace left/right
-- hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1", follow = true }))
-- hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1", follow = true }))
-- hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "r-1", follow = true }))
-- hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "r+1", follow = true }))

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- hl.bind(mainMod .. " + Z", hl.dsp.workspace.toggle_special("z"))
-- hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.window.move({ workspace = "special:z", follow = true }))

-- ##################################################################################
-- #!
-- ##! Apps
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu)) -- Launch App Menu

-- hl.bind(mainMod .. " + I", hl.dsp.exec_cmd([[XDG_CURRENT_DESKTOP="gnome" gnome-control-center]])) -- Launch Settings
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("systemsettings"))               -- Launch KDE Settings
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(taskmanager))              -- Launch task manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))                    -- Launch File Manager
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("/opt/zen-browser-bin/zen-bin")) -- Launch Zen Browser
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Equal", hl.dsp.exec_cmd("speedcrunch"))
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("zeditor")) -- Text editor

-- hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t")) -- Notification panel
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center notifications")) -- Notification panel

hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(ipc .. " bar toggle"))
hl.bind(mainMod .. " + grave", function() hl.plugin.hyprexpo.expo("toggle") end)

-- #### MISC ########################################################
-- Clipboard manager - clipse
--hl.bind(mainMod .. " + V", hl.dsp.exec_cmd([[kitty --class clipse -e 'clipse']]))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
-- character selector
-- hl.bind("SUPER + Period", hl.dsp.exec_cmd("rofimoji"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("plasma-emojier"))

-- Audio stuff
-- hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume 5"), { repeating = true, locked = true }) -- wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { repeating = true, locked = true }) -- wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true }) -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness (600 = 5% in hp laptop).
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -2")) -- brightnessctl set 600-
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +2")) -- brightnessctl set +600
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("$ipc brightness increase"), { repeating = true, locked = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("$ipc brightness decrease"), { repeating = true, locked = true })

-- ## Fixes brightness keypresses firing twice
-- Brightness Up
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[flock -n /tmp/swayosd_brightness.lock -c 'swayosd-client --brightness +5 && sleep 0.1']]))
-- Brightness Down
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[flock -n /tmp/swayosd_brightness.lock -c 'swayosd-client --brightness -5 && sleep 0.1']]))


-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. " mic-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"))

-- ########################
-- ### NEW ################
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(browser, { workspace = "1 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(fileManager, { workspace = "2 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd("zeditor", { workspace = "3 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(terminal, { workspace = "9 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd("obsidian", { workspace = "10 silent" }))
-- hl.bind("SUPER + c", hl.dsp.dpms({ action = "toggle", monitor = "eDP-1" }), { locked = true })


-- #################################################
-- ############ SUBMAP - App Launcher ##############
-- hl.bind(mainMod .. " + O", hl.dsp.submap("apps"))
-- hl.define_submap("apps", "reset", function()
--   hl.bind("O", hl.dsp.exec_cmd("obsidian"))
--   hl.bind("K", hl.dsp.exec_cmd("kitty"))
--   hl.bind("escape", hl.dsp.submap("reset"))
-- end)
