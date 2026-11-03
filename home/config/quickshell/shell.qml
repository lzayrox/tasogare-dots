import Quickshell
import Quickshell.Hyprland
import qs
import QtQuick
import "./services"

ShellRoot {

    Ipc {}

    Wallpaper {
        id: bg
        activeWallpaper: Theme.currentWallpaper
    }

    Bar {
        id: topBar
        position: "top"
        otherBar: bottomBar
    }

    Bar {
        id: bottomBar
        position: "bottom"
        otherBar: topBar
    }
}
