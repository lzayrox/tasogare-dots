local programs = require("conf.programs")
local sh = programs.shell
local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN",    hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(sh .. " reload"))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd(sh .. " session exit"))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + Z",         hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",     hl.dsp.exec_cmd(sh .. " launcher"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(sh .. " wallpapers"))
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd(sh .. " notifications"))
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd(sh .. " control-center"))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(sh .. " volume up"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(sh .. " volume down"),     { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(sh .. " volume mute"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(sh .. " volume mic-mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(sh .. " brightness up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(sh .. " brightness down"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(sh .. " media next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(sh .. " media play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(sh .. " media play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(sh .. " media prev"),       { locked = true })
