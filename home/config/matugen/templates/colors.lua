return {
    primary = "{{colors.primary.dark.hex}}",
    on_primary = "{{colors.on_primary.dark.hex}}",
    primary_container = "{{colors.primary_container.dark.hex}}",
    secondary = "{{colors.secondary.dark.hex}}",
    tertiary = "{{colors.tertiary.dark.hex}}",
    surface = "{{colors.surface.dark.hex}}",
    surface_container = "{{colors.surface_container.dark.hex}}",
    outline = "{{colors.outline.dark.hex}}",

    -- Hyprland bindings
    active_border_1 = "rgba({{colors.primary.dark.hex_stripped}}ee)",
    active_border_2 = "rgba({{colors.tertiary.dark.hex_stripped}}ee)",
    inactive_border = "rgba({{colors.surface_container_highest.dark.hex_stripped}}aa)",
    shadow = 0xee{{colors.background.dark.hex_stripped}},
    background = 0x{{colors.background.dark.hex_stripped}},
}
