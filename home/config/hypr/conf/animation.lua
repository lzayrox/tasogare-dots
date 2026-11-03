hl.curve("decel",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.0} } })
hl.curve("accel",       { type = "bezier", points = { {0.3, 0},     {0.8, 0.15} } })
hl.curve("fluidDecel",  { type = "bezier", points = { {0.16, 1},    {0.3, 1} } })
hl.curve("smoothCubic", { type = "bezier", points = { {0.25, 1},    {0.5, 1} } })

hl.animation({ leaf = "global",           enabled = true,  speed = 10,  bezier = "decel" })

hl.animation({ leaf = "windows",          enabled = true,  speed = 5.2, bezier = "fluidDecel" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 5.0, bezier = "fluidDecel", style = "popin 84%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 3.6, bezier = "accel",      style = "popin 88%" })
hl.animation({ leaf = "windowsMove",      enabled = true,  speed = 4.8, bezier = "fluidDecel" })

hl.animation({ leaf = "border",           enabled = true,  speed = 6.0, bezier = "decel" })
hl.animation({ leaf = "fade",             enabled = true,  speed = 3.8, bezier = "decel" })
hl.animation({ leaf = "fadeIn",           enabled = true,  speed = 3.4, bezier = "decel" })
hl.animation({ leaf = "fadeOut",          enabled = true,  speed = 2.8, bezier = "accel" })

hl.animation({ leaf = "layers",           enabled = true,  speed = 4.6, bezier = "fluidDecel" })
hl.animation({ leaf = "layersIn",         enabled = true,  speed = 4.4, bezier = "fluidDecel" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 3.0, bezier = "accel" })

hl.animation({ leaf = "workspaces",       enabled = true,  speed = 5.8, bezier = "smoothCubic", style = "slide" })
hl.animation({ leaf = "specialWorkspace",  enabled = true,  speed = 4.8, bezier = "fluidDecel",  style = "slidevert" })
hl.animation({ leaf = "zoomFactor",       enabled = true,  speed = 6.0, bezier = "decel" })
