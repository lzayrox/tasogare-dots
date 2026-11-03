local programs = require("conf.programs")

hl.on("hyprland.start", function()
    hl.exec_cmd(programs.shell .. " start")
end)
