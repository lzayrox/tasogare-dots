pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"

Rectangle {
    id: root

    property bool showVolume: false
    readonly property bool hasMedia: Config.media.enabled && Media.isAvailable && Media.rawTitle.length > 0

    Timer {
        id: morphTimer
        interval: Config.media.volumeMorphTimeout
        running: false
        repeat: false
        onTriggered: root.showVolume = false
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            root.triggerVolume();
        }

        function onMutedChanged() {
            root.triggerVolume();
        }
    }

    function triggerVolume() {
        showVolume = true;
        morphTimer.restart();
    }

    property real animatedWidth: (root.showVolume || !root.hasMedia)
        ? (volumeRow.implicitWidth + (Config.bar.itemSpacing * 2) + 16)
        : (mediaRow.implicitWidth + (Config.bar.itemSpacing * 2) + 16)

    Behavior on animatedWidth {
        NumberAnimation {
            duration: Config.anim.morph
            easing.type: Easing.OutCubic
        }
    }

    Layout.preferredWidth: animatedWidth
    implicitWidth: animatedWidth
    implicitHeight: Math.max(24, layout.implicitHeight + 6)
    radius: height / 2

    color: "transparent"

    scale: mouseArea.pressed ? 0.95 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    Item {
        id: layout
        anchors.centerIn: parent
        width: root.animatedWidth - (Config.bar.itemSpacing * 2) - 16
        height: Math.max(mediaRow.implicitHeight, volumeRow.implicitHeight)

        RowLayout {
            id: mediaRow
            anchors.centerIn: parent
            spacing: Config.bar.itemSpacing
            opacity: (!root.showVolume && root.hasMedia) ? 1.0 : 0.0
            visible: opacity > 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.anim.fast
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                text: Media.mediaIcon
                color: Media.isPlaying ? Theme.primary : Theme.outline

                font {
                    family: Config.font.nerdFamily
                    pixelSize: Config.font.pixelSize
                }
            }

            Text {
                text: Media.displayTrack
                color: Media.isPlaying ? Theme.textOnSurface : Theme.outline

                font {
                    family: Config.font.monoFamily
                    pixelSize: Config.font.pixelSize
                    weight: Config.font.weight
                }
            }
        }

        RowLayout {
            id: volumeRow
            anchors.centerIn: parent
            spacing: Config.bar.itemSpacing
            opacity: (root.showVolume || !root.hasMedia) ? 1.0 : 0.0
            visible: opacity > 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.anim.fast
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                text: Audio.icon
                color: Audio.muted ? Theme.outline : Theme.primary

                font {
                    family: Config.font.nerdFamily
                    pixelSize: Config.font.pixelSize
                }
            }

            Text {
                text: Audio.muted ? "Muted" : Audio.volume + "%"
                color: Audio.muted ? Theme.outline : Theme.textOnSurface

                font {
                    family: Config.font.monoFamily
                    pixelSize: Config.font.pixelSize
                    weight: Config.font.weight
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                ShellState.toggle("right");
            } else if (mouse.button === Qt.RightButton) {
                Audio.toggleMute();
                root.triggerVolume();
            } else if (mouse.button === Qt.MiddleButton) {
                if (root.hasMedia)
                    Media.togglePlay();
                else
                    Audio.toggleMute();
            }
        }

        onWheel: wheel => {
            const delta = wheel.angleDelta.y > 0 ? Config.media.scrollStep : -Config.media.scrollStep;
            Audio.adjustVolume(delta);
            root.triggerVolume();
        }
    }
}
