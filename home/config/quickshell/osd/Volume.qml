pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"

Item {
    id: root

    readonly property string targetBar: Config.osd.volume.position.bar
    readonly property string targetSection: Config.osd.volume.position.section
    property bool osdActive: false
    property double lastTriggeredAt: 0
    property bool _initialized: false
    implicitWidth: Config.osd.volume.width
    readonly property real panelHeight: Config.osd.volume.height
    implicitHeight: panelHeight

    Timer {
        id: initTimer
        interval: 600
        running: true
        repeat: false
        onTriggered: root._initialized = true
    }

    Timer {
        id: hideTimer
        interval: Config.osd.volume.timeoutMs
        running: false
        repeat: false
        onTriggered: root.osdActive = false
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            root.trigger();
        }

        function onMutedChanged() {
            root.trigger();
        }
    }

    function trigger() {
        if (!root._initialized || !Config.osd.enabled || !Config.osd.volume.enabled || !Audio.ready)
            return;
        root.lastTriggeredAt = Date.now();
        root.osdActive = true;
        hideTimer.restart();
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 12

        AnimatedIcon {
            text: Audio.icon
            iconColor: Audio.muted ? Theme.outline : Theme.primary
            iconSize: 18
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: Qt.alpha(Theme.surfaceVariant, 0.5)

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.min(1.0, Audio.volume / 100.0)
                radius: 3
                color: Audio.muted ? Theme.outline : Theme.primary

                Behavior on width {
                    NumberAnimation {
                        duration: Config.anim.fast
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        Text {
            text: Audio.muted ? "Muted" : Audio.volume + "%"
            color: Audio.muted ? Theme.outline : Theme.textOnSurface

            font {
                family: Config.font.monoFamily
                pixelSize: 13
                weight: Config.font.weight
            }
        }
    }
}
