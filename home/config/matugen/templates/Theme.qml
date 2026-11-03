pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property color primary: "{{colors.primary.dark.hex}}"
    readonly property color textOnPrimary: "{{colors.on_primary.dark.hex}}"
    readonly property color primaryContainer: "{{colors.primary_container.dark.hex}}"
    readonly property color textOnPrimaryContainer: "{{colors.on_primary_container.dark.hex}}"

    readonly property color secondary: "{{colors.secondary.dark.hex}}"
    readonly property color textOnSecondary: "{{colors.on_secondary.dark.hex}}"

    readonly property color tertiary: "{{colors.tertiary.dark.hex}}"
    readonly property color textOnTertiary: "{{colors.on_tertiary.dark.hex}}"
    readonly property color tertiaryContainer: "{{colors.tertiary_container.dark.hex}}"
    readonly property color textOnTertiaryContainer: "{{colors.on_tertiary_container.dark.hex}}"

    readonly property color error: "{{colors.error.dark.hex}}"
    readonly property color textOnError: "{{colors.on_error.dark.hex}}"
    readonly property color errorContainer: "{{colors.error_container.dark.hex}}"
    readonly property color textOnErrorContainer: "{{colors.on_error_container.dark.hex}}"

    readonly property color surface: "{{colors.surface.dark.hex}}"
    readonly property color textOnSurface: "{{colors.on_surface.dark.hex}}"
    readonly property color surfaceVariant: "{{colors.surface_variant.dark.hex}}"
    readonly property color textOnSurfaceVariant: "{{colors.on_surface_variant.dark.hex}}"
    readonly property color surfaceContainer: "{{colors.surface_container.dark.hex}}"

    readonly property color background: "{{colors.background.dark.hex}}"
    readonly property color textOnBackground: "{{colors.on_background.dark.hex}}"
    readonly property color outline: "{{colors.outline.dark.hex}}"
}
