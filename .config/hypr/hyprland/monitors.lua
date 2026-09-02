----------------
--- Monitors ---
--- https://wiki.hypr.land/Configuring/Basics/Monitors
local laptopMonitor = { output = "eDP-1", mode = "highres", position = "0x0", scale = 1 }
hl.monitor(laptopMonitor)

hl.monitor({ -- E303 pool room
    output = "desc:Dell Inc. DELL U3223QE",
    mode = "3840x2160@60",
    position = "auto-center-up",
    scale = 1.2,
})

hl.monitor({ -- CN student lab
    output = "desc:Dell Inc. DELL S2722QC",
    mode = "3840x2160@60",
    position = "auto-center-up",
    scale = 1.25,
})

hl.monitor({ output = "", mode = "highres", position = "auto-center-up", scale = 1 })

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
    hl.workspace_rule({ workspace = tostring(i + 10), monitor = "DP-1" })
end

-- Helper function to check if eDP-1 is currently active/enabled
local function isInternalMonitorActive()
    local monitors = hl.get_monitors()
    for _, mon in ipairs(monitors) do
        if mon.name == "eDP-1" then
            return true
        end
    end
    return false
end

function DisableLaptopMonitor()
    if #hl.get_monitors() > 1 then
        hl.monitor({ output = laptopMonitor.output, disabled = true })
    end
end

function EnableLaptopMonitor()
    if not isInternalMonitorActive() then
        hl.monitor(laptopMonitor)
        os.execute("hyprctl reload")
    end
end

hl.bind("switch:on:Lid Switch", DisableLaptopMonitor, { locked = true })
hl.bind("switch:off:Lid Switch", EnableLaptopMonitor, { locked = true })


hl.bind("SUPER + P", function()
    local monitors = hl.get_monitors()
    local msg = "Active Monitors (" .. #monitors .. "):\n"

    for i, m in ipairs(monitors) do
        msg = msg .. string.format("[%d] %s, %s\n", i, m.name, m.description)
    end

    hl.notification.create({ text = msg, timeout = 5000 })
end)
