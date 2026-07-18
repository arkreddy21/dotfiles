-- See https://wiki.hypr.land/Configuring/Basics/Binds/
-- See https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local mainMod = "SUPER"
local ipc = "noctalia msg "
local terminal = "kitty"
local fileManager = "dolphin"
local browser = "zen-browser"
local taskmanager = "kitty -e btop"
-- local menu = "rofi -show drun"
local menu = ipc .. " panel-toggle launcher"

----------------------------------------------------------------------------------
-- ##! Actions

-- hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
--hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("wlogout -p layer-shell"))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
hl.bind(mainMod .. " + ALT + Delete", hl.dsp.exec_cmd(ipc .. "panel-open session"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"))

hl.bind(mainMod .. " + X", hl.dsp.window.close(), {desc = "close active window"})
hl.bind(mainMod .. " + ALT + X", hl.dsp.window.kill(), {desc = "kill active window"})
hl.bind(mainMod .. " + ALT + M", hl.dsp.exit(), {desc = "exit hyprland"})

hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"), {desc = "lock screen"})
hl.bind("SUPER + ALT + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), { locked = true, desc = "suspend" })

hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("voxtype record start"))                    -- copilot key
hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("voxtype record stop"), { release = true }) -- copilot key
-- hl.bind("SUPER + P", hl.dsp.exec_cmd([[kitty --class hyprmoncfg -e 'hyprmoncfg']]))             -- also opens with display fn key (f9)
-- Color picker
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))                                  -- Pick color (Hex) >> clipboard

-- Screenshot edit
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]])) -- Screen snip >> edit
-- OCR
hl.bind("CTRL + SHIFT + Print",
    hl.dsp.exec_cmd(
        [[grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"]])) -- Screen snip to text >> clipboard

-- Recording stuff
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh --fullscreen-sound"), { desc = "Record screen (with sound)" })
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh --fullscreen"),      { desc = "Record screen (no sound)" })
hl.bind(mainMod .. " + SHIFT + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh"),           { desc = "Record region (no sound)" })
-- Screenshots
-- hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("Print", hl.dsp.exec_cmd("flameshot gui"), {desc = "screenshot a region"})
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"),                {desc = "screenshot a region to clipboard only"})
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot -m window"),                                {desc = "screenshot a window"})
hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"),        {desc = "screenshot a window to clipboard only"})
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1"),                         {desc = "screenshot entire screen"})
hl.bind("ALT + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 --clipboard-only"), {desc = "screenshot entire screen to clipboard only"})

hl.bind(mainMod .. " + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }), {desc = "OBS Studio: start/stop Recording"})

----------------------------------------------------------------------
-- ##! Apps
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu)) -- Launch App Menu

hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("systemsettings"), {desc = "open KDE settings"})
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(taskmanager), {desc = "open task manager"})
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), {desc = "open file manager"})
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(browser), {desc = "launch web browser"})
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"), {desc = "launch obsidian"})
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), {desc = "launch terminal: kitty"})
hl.bind(mainMod .. " + Equal", hl.dsp.exec_cmd("speedcrunch"), {desc = "launch calculator: speedcrunch"})
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("zeditor"), {desc = "launch zed editor"})

-- hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t")) -- Notification panel
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center notifications")) -- Notification panel

-- Clipboard manager - clipse / noctalia
--hl.bind(mainMod .. " + V", hl.dsp.exec_cmd([[kitty --class clipse -e 'clipse']]))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))

-- character selector
-- hl.bind("SUPER + Period", hl.dsp.exec_cmd("rofimoji"))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd("plasma-emojier"))


--------------------------------------------------------------------------------
-- Window management

-- Positioning mode
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float())
hl.bind(mainMod .. " + ALT+ P", hl.dsp.window.pin())
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT + Backslash", hl.dsp.window.resize({ x = 720, y = 540, "exact" })) --make window not amogus large

-- Window groups
hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + G", hl.dsp.group.next())
hl.bind(mainMod .. " + ALT + G", hl.dsp.group.prev())

--#/# bind = SUPER + ←/↑/→/↓,, -- Focus in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local vimkey = { "h", "l", "k", "j"}
    local focusdir = { "l", "r", "u", "d" }
    hl.bind(mainMod .. " + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }))
    hl.bind(mainMod .. " + " .. vimkey[i],   hl.dsp.focus({ direction = focusdir[i] }))
    hl.bind(mainMod .. " + SHIFT + " .. arrowkey[i], hl.dsp.window.swap({ direction = focusdir[i] }))
    hl.bind(mainMod .. " + SHIFT + " .. vimkey[i],   hl.dsp.window.swap({ direction = focusdir[i] }))
end

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
hl.bind(mainMod .. " + B", toggle_split)

---------------------------------------------------------------------------------
-- Workspace management

-- special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("work"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:work", follow = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + W", hl.dsp.window.move({ workspace = "special:work", follow = false }))

-- Switch workspaces, move windows
for i = 1, 10 do
    hl.bind(mainMod .. "+" .. (i % 10), hl.dsp.focus({ workspace = i }), { description = "Workspace: Focus " .. i })
    hl.bind(mainMod .. " + ALT + " .. (i % 10), hl.dsp.focus({ workspace = i + 10 }))
    hl.bind(mainMod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i, follow = true }))
    hl.bind(mainMod .. " + SHIFT + ALT + " .. (i % 10), hl.dsp.window.move({ workspace = i + 10, follow = true }))
    hl.bind(mainMod .. " + CTRL + " .. (i % 10), hl.dsp.window.move({ workspace = i, follow = false }))
    hl.bind(mainMod .. " + CTRL + ALT + " .. (i % 10), hl.dsp.window.move({ workspace = i + 10, follow = false }))
end

--/# bind = Super, Page_↑/↓,, # Workspace: focus left/right
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "r-1" }))

--/# bind = Super+Shift, Page_↑/↓,, # Window: move to workspace left/right
hl.bind(mainMod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "r+1", follow = true }))
hl.bind(mainMod .. " + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "r-1", follow = true }))
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "r+1", follow = false }))
hl.bind(mainMod .. " + CTRL + Page_Up", hl.dsp.window.move({ workspace = "r-1", follow = false }))

-- #### MISC ########################################################

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. " mic-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true })

---------------------------------------------
--- Old and unnecessary

-- --- auto open apps on a single bind
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(browser, { workspace = "1 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(fileManager, { workspace = "2 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd("zeditor", { workspace = "3 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd(terminal, { workspace = "9 silent" }))
-- hl.bind("SUPER + w", hl.dsp.exec_cmd("obsidian", { workspace = "10 silent" }))
-- hl.bind("SUPER + c", hl.dsp.dpms({ action = "toggle", monitor = "eDP-1" }), { locked = true })

-- ############ SUBMAP - App Launcher ##############
-- hl.bind(mainMod .. " + O", hl.dsp.submap("apps"))
-- hl.define_submap("apps", "reset", function()
--   hl.bind("O", hl.dsp.exec_cmd("obsidian"))
--   hl.bind("K", hl.dsp.exec_cmd("kitty"))
--   hl.bind("escape", hl.dsp.submap("reset"))
-- end)

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

-- Audio stuff
-- hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume 5"), { repeating = true, locked = true }) -- wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { repeating = true, locked = true }) -- wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true }) -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle


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
