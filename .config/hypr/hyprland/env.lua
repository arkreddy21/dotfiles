hl.env("XCURSOR_THEME", "Breeze_Light")
-- hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
-- hl.env("HYPRCURSOR_SIZE", "24")

hl.env("HYPRSHOT_DIR", "/home/arama/Pictures/Screenshots")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("GDK_BACKEND", "wayland,x11,*")

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- ------- Themes ---------
hl.env("QT_QPA_PLATFORMTHEME", "kde") -- kde (or) gnome with qgnomeplatform-qt(5/6)-git installed
-- hl.env("GTK_THEME", "Adwaita:light")
hl.env("ICON_THEME", "Papirus")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- ------- Wayland -----------
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- hl.env("MOZ_ENABLE_WAYLAND", "1")
