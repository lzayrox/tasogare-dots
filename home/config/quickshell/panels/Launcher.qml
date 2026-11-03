pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../services"
import "./launcher" as LauncherModules

Item {
    id: root

    property real panelHeight: Search.isWallpaperMode ? Config.panels.wallpapers.height : Config.panels.launcher.height
    implicitWidth: Search.isWallpaperMode ? Config.panels.wallpapers.width : Config.panels.launcher.width
    implicitHeight: root.panelHeight

    Component.onCompleted: {
        const ov = String(ShellState.activePanelOverride || "").toLowerCase();
        if (ov === "wallpapers" || ov === "wallpaper") {
            Search.enterWallpaperMode();
        } else {
            Search.clear();
        }
        searchBar.focusInput();
    }

    Component.onDestruction: {
        Search.clear();
    }

    Connections {
        target: ShellState

        function onActivePanelOverrideChanged() {
            if (ShellState.isOpen) {
                Search.syncFromOverride(ShellState.activePanelOverride);
                searchBar.focusInput();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            LauncherModules.AppList {
                id: appList
                anchors.fill: parent
                opacity: Search.isWallpaperMode ? 0.0 : 1.0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.anim.fast
                        easing.type: Easing.OutCubic
                    }
                }
            }

            LauncherModules.WallpaperList {
                id: wallpaperList
                anchors.fill: parent
                opacity: Search.isWallpaperMode ? 1.0 : 0.0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.anim.fast
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        LauncherModules.SearchBar {
            id: searchBar
            Layout.fillWidth: true
            onPreviousRequested: {
                if (Search.isWallpaperMode)
                    wallpaperList.decrementCurrentIndex();
                else
                    appList.decrementCurrentIndex();
            }
            onNextRequested: {
                if (Search.isWallpaperMode)
                    wallpaperList.incrementCurrentIndex();
                else
                    appList.incrementCurrentIndex();
            }
            onAcceptedInput: {
                if (Search.isWallpaperMode)
                    wallpaperList.applyCurrent();
                else
                    appList.executeCurrent();
            }
        }
    }
}
