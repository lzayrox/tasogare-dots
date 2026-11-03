pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"
import "../utils" as Utils

Item {
    id: root

    implicitWidth: Config.panels.statusDetails.width
    readonly property real panelHeight: Config.panels.statusDetails.height
    implicitHeight: panelHeight

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 10

        DarkGlassCard {
            Layout.fillWidth: true
            implicitHeight: 64
            radius: 12
            visible: Media.isAvailable

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: Media.rawTitle.length > 0 ? Media.rawTitle : "Sin pista"
                        color: Theme.textOnSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font {
                            family: Config.font.family
                            pixelSize: 13
                            weight: 600
                        }
                    }

                    Text {
                        text: Media.rawArtist.length > 0 ? Media.rawArtist : "Desconocido"
                        color: Theme.outline
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font {
                            family: Config.font.family
                            pixelSize: 11
                        }
                    }
                }

                RowLayout {
                    spacing: 4

                    IconButton {
                        icon: Utils.Icons.mediaPrev
                        subtle: true
                        onClicked: Media.previousTrack()
                    }

                    IconButton {
                        icon: Media.mediaIcon
                        onClicked: Media.togglePlay()
                    }

                    IconButton {
                        icon: Utils.Icons.mediaNext
                        subtle: true
                        onClicked: Media.nextTrack()
                    }
                }
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
                icon: Utils.Icons.volumeHigh
                title: "Silencio"
                subtitle: Audio.muted ? "Silenciado" : "Activo"
                active: Audio.muted
                onClicked: Audio.toggleMute()
            }
        }
    }
}
