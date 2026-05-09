require("~/.config/hypr2/hyprland/env.lua")
require("~/.config/hypr2/hyprland/execs.lua")
require("~/.config/hypr2/hyprland/rules.lua")
require("~/.config/hypr2/hyprland/keybinds.lua")
require("~/.config/hypr2/noctalia/noctalia-colors.lua")


----------------
--- Monitors ---
--- https://wiki.hypr.land/Configuring/Basics/Monitors
hl.monitor({
    output = "",
    mode = "preferred", -- preferred, highres, highrr
    position = "auto",  -- auto, auto-right/left/up/down, auto-center-right/left/up/down
    scale = 1,
    --vrr = 1,
})
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
        sensitivity = 0,  -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1.0,
            drag_lock = 0,  -- 1: delay, 2: sticky
        }
    },
    binds = {
        -- scroll_event_delay = 0,
    },
    -- gestures = {},
    group = {
        col = {
            border_active = secondary,
            border_inactive = surface,
            locked_active = error,
            locked_inactive = surface,
        },
        groupbar = {
            col = {
                active = secondary,
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
            text_color = "rgb(000000)",
            text_padding = 16,
            indicator_height = 22,  -- Make the indicator tall enough to render text inside
            text_offset = -11,  -- about half the indicator height
            height = 1,
            scrolling = false,
        }
    }
})

---------------
--- layouts ---
---------------

hl.config({
    dwindle = {
       	preserve_split = true,
        pseudotile = true,
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

------------
--- animations, gestures, misc, custom (monitor workspace binding)
