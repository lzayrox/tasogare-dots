pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property color primary: "#98ccf9"
    readonly property color textOnPrimary: "#003350"
    readonly property color primaryContainer: "#034b71"
    readonly property color textOnPrimaryContainer: "#cbe6ff"

    readonly property color secondary: "#b8c8d9"
    readonly property color textOnSecondary: "#22323f"

    readonly property color tertiary: "#d0bfe7"
    readonly property color textOnTertiary: "#372b4a"
    readonly property color tertiaryContainer: "#4e4162"
    readonly property color textOnTertiaryContainer: "#ecdcff"

    readonly property color error: "#ffb4ab"
    readonly property color textOnError: "#690005"
    readonly property color errorContainer: "#93000a"
    readonly property color textOnErrorContainer: "#ffdad6"

    readonly property color surface: "#101417"
    readonly property color textOnSurface: "#e0e3e8"
    readonly property color surfaceVariant: "#42474d"
    readonly property color textOnSurfaceVariant: "#c1c7ce"
    readonly property color surfaceContainer: "#1c2024"

    readonly property color background: "#101417"
    readonly property color textOnBackground: "#e0e3e8"
    readonly property color outline: "#8c9198"
}
