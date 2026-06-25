require("hyprland.env")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.keybinds")
pcall(require, "monitors")  -- protected call


local primary = "rgb(cba6f7)"     --mocha mauve
local surface = "rgb(1e1e2e)"     -- mocha base
local surfacea = "rgba(1e1e2e42)" -- mocha base with alpha (translucent)
local secondary = "rgb(89dceb)"   -- mocha sky
local error = "rgb(f38ba8)"       --mocha red
local text = "rgb(cdd6f4)"
local transparent = "rgba(00000000)"

-- local primary = "rgb(8fbcbb)"   -- nord 7
-- local surface = "rgb(eceff4)"   -- nord 6
-- local secondary = "rgb(89dceb)" -- mocha sky
-- local error = "rgb(bf616a)"     --nord red

----------------
--- Monitors ---
--- https://wiki.hypr.land/Configuring/Basics/Monitors
-- hl.monitor({
--     output = "",
--     mode = "preferred", -- preferred, highres, highrr
--     position = "auto",  -- auto, auto-right/left/up/down, auto-center-right/left/up/down
--     scale = 1,
-- })
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "DP-1" })

-------------------
-- Look And Feel --
hl.config({
    general = {
        layout = "dwindle",
        gaps_in = 1,
        gaps_out = 4,
        border_size = 2,
        gaps_workspaces = 50,
        resize_on_border = true,
        -- no_focus_fallback = true, -- doesn't do anything with focus follow_mouse
        -- Refer to Tearing if necessary
        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing
        col = {
            active_border = primary,
            inactive_border = transparent,
        },
        snap = {
            enabled = true
        },
        allow_tearing = false,
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.07,
        dim_special = 0.5,
        blur = {
            enabled = false,
            size = 3,
            passes = 2,
            popups = true,
            popups_ignorealpha = 0.6,
        },
        shadow = {
            enabled = false,
        },
        glow = {
            enabled = false
        }
    },
    group = {
        col = {
            border_active = primary,
            border_inactive = surface,
        },
        groupbar = {
            col = {
                active = primary,
                inactive = surface,
                locked_active = error,
                locked_inactive = surface,
            },
            render_titles = true,
            rounding = 4,
            round_only_edges = false,
            font_size = 13,
            font_family = "IBM Plex Sans",
            font_weight_active = "bold",
            font_weight_inactive = "bold",
            text_color = "rgb(1e1e2e)",
            text_color_inactive = text,
            text_padding = 16,
            indicator_height = 22, -- Make the indicator tall enough to render text inside
            text_offset = -11,     -- about half the indicator height
            height = 1,
            scrolling = false,
        }
    },
    binds = {
        hide_special_on_workspace_change = true
    },
    misc = {
        disable_hyprland_logo = true,   -- If true disables the random hyprland logo / anime girl background. :(
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        --font_family = "Noto Sans",
        vrr = 3,                        -- 3: fullscreen with video or games only
        mouse_move_enables_dpms = true, --switch to false to prevent accidental wake up
        key_press_enables_dpms = true,

        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        swallow_regex = "(foot|kitty|Alacritty)",

        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = true,

        -- initial_workspace_tracking = 1
        focus_on_activate = true,
    },
    debug = {
        -- overlay = true,
        -- vfr = true
    }
})

---------------
--- layouts ---
---------------

hl.config({
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false,
    },
    master = {
        mfact = 0.6
    },
    scrolling = {
        column_width = 0.6,
        focus_fit_method = 1,
        follow_focus = true,
    },
})

-- curves
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })

-- animations
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "md3_decel", style = "slidefade 15%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "md3_decel", style = "slidefadevert 15%" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "md3_decel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.5, bezier = "menu_accel" })


-- Plugin: Overview
-- https://github.com/sandwichfarm/hyprexpo
hl.config({
    plugin = {
        hyprexpo = {
            columns = 3,
            gaps_in = 12,
            gaps_out = 12,
            bg_col = surface,
            tile_rounding = 6,
            -- workspace_method = "first 1", -- [center/first] [workspace] e.g. first 1 or center m+1
            border_color_focus = primary,
            border_color_hover = secondary,
            label_text_mode = "id",
            label_bg_shape = "rounded",
            label_color_default = text,
            label_color_focus = primary,
            label_color_hover = secondary,
            drag_drop_proxy_color = surfacea,
            drag_drop_proxy_active_color = surfacea
        },
        -- dynamic_cursors = {
        --     mode = 'stretch'
        -- }
    },
})

hl.plugin.hyprexpo.gesture({
    fingers = 4,
    direction = "vertical",
    action = "expo",
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "magic" })
hl.gesture({ fingers = 3, direction = "pinch", action = "cursorZoom", mode = "live" })

----- Inputs and Devices -----
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "altgr-intl",   -- other layout+variants: us + altgr-intl,  eu
        kb_options = "caps:swapescape,rupeesign:4",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1.0,
            drag_lock = 0, -- 1: delay, 2: sticky
        }
    },
})

hl.device({
    name = "bluetooth-mouse-m336/m337/m535-mouse",
    sensitivity = -0.3
})

hl.device({
    name = "logitech-optical-usb-mouse",
    sensitivity = 1
})

-- Required for permission rules to apply (disabled by default)
-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })
-- hl.permission({
--     binary = "/usr/(bin|local/bin)/hyprpm",
--     type = "plugin",
--     mode = "allow",
-- })
