hl.on("hyprland.start", function()
    -- Core components
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("hyprctl setcursor Breeze_Light 24")
end)

hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
    -- uses a blocking exec function and sleeps a bit to give things time to close
    -- you might also want to kill troublesome/crashing non-systemd background services here:
    -- os.execute("pkill wallpaperthing; systemctl --user stop hyprland-session.target && sleep 0.1")
end)
