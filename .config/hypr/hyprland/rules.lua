----------------- Workspace Rules -----------------
hl.workspace_rule({ workspace = "1", layout = "master" })
hl.workspace_rule({ workspace = "special:magic", layout = "scrolling" })
hl.workspace_rule({ workspace = "special:work", layout = "scrolling" })

----------------- Window Rules -----------------

-- hl.window_rule({ match = { class = ".*" }, no_blur = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false},
    no_focus = true,
})

---- Dialog windows
local special_windows =
"^(Open File|Pick File|Select a File|Save a File|Save File|Choose wallpaper|Open Folder|Save As|Library|File Upload|wants to save|wants to open|Save Image|Choose a|Select file|Select what to share|Enter name of file|All Files|Open Document)(.*)$"
hl.window_rule({
    match = { title = special_windows },
    float = true,
    center = true,
    size = { "monitor_w*0.50", "monitor_h*0.70" },
    dim_around = true,
})

---- TUIs
local tuis =
"^(wiremix|wlctl|bluetui|org.pulseaudio.pavucontrol|nm-connection-editor|pavucontrol|org.gnome.Characters|org.kde.plasma.emojier)$"
hl.window_rule({
    match = { class = tuis },
    float = true,
    center = true,
    size = { "monitor_w*0.45", "monitor_h*0.55" },
    dim_around = true,
})

-- hyprmoncfg
hl.window_rule({
    match = { class = "hyprmoncfg" },
    float = true,
    center = true,
    size = { "monitor_w*0.8", "monitor_h*0.8" },
    dim_around = true,
})

-- Clipse - different w/h ratio
hl.window_rule({
    match = { class = "clipse" },
    float = true,
    center = true,
    size = { "monitor_w*0.35", "monitor_h*0.60" },
    dim_around = true,
})

-- Floating windows
hl.window_rule({ match = { class = "org.gnome.NautilusPreviewer" }, float = true })
-- hl.window_rule({ match = { class = "^(blueberry\\.py)$" }, float = true })
-- hl.window_rule({ match = { class = ".*plasmawindowed.*" }, float = true })
hl.window_rule({ match = { class = "kcm_.*" }, float = true })
hl.window_rule({ match = { class = ".*bluedevilwizard" }, float = true })
hl.window_rule({ match = { title = ".*Welcome" }, float = true })
hl.window_rule({
    match = { class = "org.freedesktop.impl.portal.desktop.kde" },
    float = true,
    size = { "monitor_w*0.60", "monitor_h*0.65" },
})
hl.window_rule({
    match = { class = "^(nm-connection-editor)$" },
    float = true,
    size = { "monitor_w*0.45", "monitor_h*0.45" },
    center = true,
})
hl.window_rule({
    match = { class = "^(pavucontrol)$" },
    float = true,
    size = { "monitor_w*0.45", "monitor_h*0.45" },
    center = true,
})

-- Tiling
hl.window_rule({ match = { class = "^dev\\.warp\\.Warp$" }, tile = true })
hl.window_rule({ match = { title = "LTspice" }, tile = true })

-- PiP
local pip = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
hl.window_rule({
    match = { title = pip },
    float = true,
    -- keep_aspect_ratio = true,
    move = { "monitor_w*0.74", "monitor_h*0.04" },
    size = { "monitor_w*0.25", "monitor_h*0.25" },
    pin = true,
    no_initial_focus = true,
    suppress_event = "activatefocus",
    content = "video"
})

-- Tearing (check if tearing itself is enabled for immeadiate rule to take effect)
hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" }, immediate = true })

hl.window_rule({ match = {class = "flameshot"}, no_anim = true, float = true, center = true})

-- prevent kitty from focusing because of ssh pings. or should I add suppress_event = 'activatefocus'
hl.window_rule({ match = { class = 'kitty' }, focus_on_activate = false })

-- hl.window_rule({
--     match = { class = "kitty" },
--     opacity = "0.96 0.96", -- Active and inactive opacity multipliers
--     no_blur = false
-- })
-- 

----------------- Layer Rules -----------------
hl.layer_rule({ match = { namespace = "rofi" }, dim_around = true })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
hl.layer_rule({ match = { namespace = "hyprpicker" }, no_anim = true })

-- hl.layer_rule({
--     name = "noctalia",
--     match = {
--         namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
--     },
--     ignore_alpha = 0.5,
--     blur = true,
--     blur_popups = true,
-- })

