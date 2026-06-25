hl.on("hyprland.start", function()
    -- Core components
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

    hl.exec_cmd("noctalia")
    hl.exec_cmd("hyprpm reload")
    -- hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start voxtype")
    hl.exec_cmd("systemctl --user start hyprmoncfgd")
    -- hl.exec_cmd("clipse -listen")
    -- hl.exec_cmd("waybar")
    -- hl.exec_cmd("swaync")
    -- hl.exec_cmd("swayosd-server")
    -- hl.exec_cmd("qs -c $qsConfig")

    -- Polkit Agents (use one)
    -- handled by noctalia
    -- hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")


    -- Unnecessary-----------------------------------------------------------
    -- hl.exec_cmd("easyeffects --gapplication-service")  -- Audio effects
    -- hl.exec_cmd("fcitx5")  -- Input method
    -- hl.exec_cmd("gnome-keyring-daemon --start --components=secrets; dbus-update-activation-environment --all;")

    -- hl.exec_cmd("dbus-update-activation-environment --all")
    -- hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- Some fix idk

    -- hl.exec_cmd("swww-daemon --format xrgb")  -- conflicts hyprpaper
    -- hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent & gammastep -O 4500")  -- automatic night light

    -- Old ---------------------
    -- needed for vscode. Exec `code --password-store=kwallet6`
    -- hl.exec_cmd("/usr/lib/pam_kwallet_init")
    -- ---------------------
end)
