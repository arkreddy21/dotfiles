require("hyprland.env")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.keybinds")
require("monitors")

local primary = "rgb(cba6f7)"   --mocha mauve
local surface = "rgb(1e1e2e)"   -- mocha base
local surfacea = "rgba(1e1e2e42)"   -- mocha base with alpha (translucent)
local secondary = "rgb(89dceb)" -- mocha sky
local error = "rgb(f38ba8)"     --mocha red
local text = "rgb(cdd6f4)"

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
--     --vrr = 1,
-- })
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "DP-1" })

-------------------
-- Look And Feel --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
    general = {
        layout = "dwindle",
        gaps_in = 2,
        gaps_out = 4.,
        border_size = 2,
        gaps_workspaces = 50,
        resize_on_border = true,
        -- no_focus_fallback = true, -- doesn't do anything with focus follow_mouse
        -- Refer to Tearing if necessary
        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing
        col = {
            active_border = primary,
            inactive_border = surface,
        },
        snap = {
            enabled = true
        }
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.07,
        dim_special = 0.5,
        blur = {
            enabled = true,
            size = 14,
            passes = 4,
            brightness = 1,
            noise = 0.01,
            contrast = 1,
            popups = true,
            popups_ignorealpha = 0.6,
        }
    },
    input = {
        kb_options = "caps:swapescape",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1.0,
            drag_lock = 0, -- 1: delay, 2: sticky
        }
    },
    binds = {
        -- scroll_event_delay = 0,
    },
    -- gestures = {},
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
            font_family = Hack,
            font_weight_active = bold,
            font_weight_inactive = bold,
            text_color = "rgb(1e1e2e)",
            text_color_inactive = text,
            text_padding = 16,
            indicator_height = 22, -- Make the indicator tall enough to render text inside
            text_offset = -11,     -- about half the indicator height
            height = 1,
            scrolling = false,
        }
    },
    misc = {
        disable_hyprland_logo = true,      -- If true disables the random hyprland logo / anime girl background. :(
        force_default_wallpaper = 0,       -- Set to 0 or 1 to disable the anime mascot wallpapers
        --font_family = "Noto Sans",
        vrr = 0,
        mouse_move_enables_dpms = true,    --switch to false to prevent accidental wake up
        key_press_enables_dpms = true,

        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        swallow_regex = "(foot|kitty|allacritty|Alacritty)",

        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = true,

        -- initial_workspace_tracking = 1
        focus_on_activate = true,
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
hl.workspace_rule({ workspace = "1", layout = "master" })
hl.workspace_rule({ workspace = "special:magic", layout = "scrolling" })

hl.device({
    name = "bluetooth-mouse-m336/m337/m535-mouse",
    sensitivity = -0.3
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "magic" })
-- hl.gesture({ fingers = 4, direction = "vertical", action = "fullscreen" })
hl.plugin.hyprexpo.gesture({
    fingers = 4,
    direction = "vertical",
    action = "expo",
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


-- monitor assignment rules
hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })

-- Depends on connected port
-- hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "12", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "13", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "14", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "15", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "16", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "17", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "18", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "19", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "20", monitor = "HDMI-A-1" })

-- Plugin: Overview
hl.config({
    plugin = {
        hyprexpo = {
            columns = 3,
            gaps_in = 12,
            gaps_out = 12,
            bg_col = surface,
            tile_rounding = 4,
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
    },
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
