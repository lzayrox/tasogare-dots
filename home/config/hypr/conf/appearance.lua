local colors = require("conf.colors")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = colors.background,
    },

    general = {
        gaps_in          = 5,
        gaps_out         = 20,

        border_size      = 2,

        col              = {
            active_border   = { colors = { colors.active_border_1, colors.active_border_2 }, angle = 45 },
            inactive_border = colors.inactive_border,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing    = false,

        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.85,
        inactive_opacity = 0.9,

        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = colors.shadow,
        },

        blur             = {
            enabled  = true,
            size     = 5,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
