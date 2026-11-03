pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"
import "../utils" as Utils

Item {
    id: root

    implicitWidth: Config.panels.controlCenter.width
    readonly property real panelHeight: Config.panels.controlCenter.height
    implicitHeight: panelHeight

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 12

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            QuickToggle {
                icon: Network.icon
                title: "Wi-Fi"
                subtitle: Network.ssid
                active: Network.wifiEnabled
                onClicked: Network.toggleWifi()
            }

            QuickToggle {
                icon: Theme.mode === "light" ? Utils.Icons.lightMode : Utils.Icons.darkMode
                title: "Tema"
                subtitle: Theme.mode === "light" ? "Claro" : "Oscuro"
                active: Theme.mode === "light"
                onClicked: {
                    Theme.mode = Theme.mode === "light" ? "dark" : "light";
                }
            }

            QuickToggle {
                icon: Utils.Icons.volumeHigh
                title: "OSD Audio"
                subtitle: Config.osd.enabled ? "Activo" : "Apagado"
                active: Config.osd.enabled
                onClicked: Config.osd.enabled = !Config.osd.enabled
            }

            QuickToggle {
                icon: Utils.Icons.terminal
                title: "Terminal"
                subtitle: "Flotante"
                active: false
                onClicked: ControlCenter.openFloatingTerminal()
            }
        }

        GlassSlider {
            icon: Audio.icon
            value: Audio.volume
            from: 0
            to: 100
            muted: Audio.muted
            displayText: Audio.muted ? "0%" : Audio.volume + "%"
            onIconClicked: Audio.toggleMute()
            onMoved: nextVal => Audio.setVolume(nextVal)
        }

        GlassSlider {
            icon: Utils.Icons.widthArrows
            value: Config.bar.width
            from: 40
            to: 100
            displayText: Config.bar.width + "%"
            onIconClicked: Config.bar.width = Config.bar.width < 100 ? 100 : 75
            onMoved: nextVal => Config.bar.width = nextVal
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item {
                Layout.fillWidth: true
            }

            IconButton {
                icon: Utils.Icons.suspend
                onClicked: ControlCenter.suspend()
            }

            IconButton {
                icon: Utils.Icons.restart
                onClicked: ControlCenter.reboot()
            }

            IconButton {
                icon: Utils.Icons.power
                danger: true
                onClicked: ControlCenter.poweroff()
            }
        }
    }
}
