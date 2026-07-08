-- keybinds.lua (or inline in hyprland.lua)
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

-- Actions
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty")) -- Open kitty terminal
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- Close current window
hl.bind(mainMod .. " + M", hl.dsp.exit()) -- Exit Hyprland
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar")) -- Open file manager
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen()) -- Fullscreen
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("ags -i ags2-shell toggle launcher")) -- Open rofi
hl.bind(mainMod .. " + MINUS", hl.dsp.layout("togglesplit")) -- Toggle split (dwindle)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave")) -- Open browser

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Media / hardware keys (no modifier)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86WLAN", hl.dsp.exec_cmd("nmcli radio wifi toggle"))
hl.bind("XF86Refresh", hl.dsp.exec_cmd("wtype -k F5"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ monitor = "d" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))

-- Switch workspaces and move windows with mainMod + [0-9]
for i = 1, 10 do
	local key = i % 10 -- key 0 maps to workspace 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces with mainMod + mouse scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
