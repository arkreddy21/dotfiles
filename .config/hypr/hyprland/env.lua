-- ############ Themes #############
-- hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine") -- kde (or) gnome with qgnomeplatform-qt(5/6)-git installed
-- hl.env("GTK_THEME", "Adwaita:light")
-- hl.env("ICON_THEME", "Adwaita")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")
-- hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- ######## Screen tearing #########
-- hl.env("WLR_DRM_NO_ATOMIC", "1")

-- ############ Others #############
-- ############ Wayland #############
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

-- See https://wiki.hyprland.org/Configuring/Environment-variables/

-- Try Hyprcursor
-- https://sakshatshinde.github.io/hyprcursor-themes/
hl.env("XCURSOR_THEME", "Vimix-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("HYPRSHOT_DIR", "/home/arkreddy/Pictures/Screenshots")

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- hl.env("XDG_SESSION_DESKTOP", "KDE")
-- hl.env("XDG_CURRENT_DESKTOP", "KDE")
-- hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("QT_QPA_PLATFORM", "wayland;xcb")
