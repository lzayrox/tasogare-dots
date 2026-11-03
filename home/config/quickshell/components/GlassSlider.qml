pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../services"

DarkGlassCard {
    id: root

    property string icon: ""
    property real value: 0
    property real from: 0
    property real to: 100
    property bool muted: false
    property string displayText: Math.round(root.value) + "%"

    signal iconClicked()
    signal moved(real newValue)

    Layout.fillWidth: true
    implicitHeight: 44
    radius: 12

    readonly property real normalizedValue: {
        const span = root.to - root.from;
        if (span <= 0)
            return 0;
        return Math.max(0.0, Math.min(1.0, (root.value - root.from) / span));
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 12
        spacing: 10

        Item {
            Layout.preferredWidth: 22
            Layout.preferredHeight: 22
            Layout.alignment: Qt.AlignVCenter

            AnimatedIcon {
                anchors.centerIn: parent
                text: root.icon
                iconColor: root.muted ? Theme.outline : Theme.primary
                iconSize: 16
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.iconClicked()
            }
        }

        Item {
            id: track
            Layout.fillWidth: true
            implicitHeight: 34
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 6
                radius: 3
                color: Qt.alpha(Theme.outline, 0.25)
            }

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * root.normalizedValue
                height: 6
                radius: 3
                color: root.muted ? Theme.outline : Theme.primary

                Behavior on width {
                    enabled: !trackMouse.pressed
                    NumberAnimation {
                        duration: Config.anim.fast
                        easing.type: Easing.OutCubic
                    }
                }
            }

            MouseArea {
                id: trackMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                function emitAtPos(mouseX) {
                    const ratio = Math.max(0.0, Math.min(1.0, mouseX / width));
                    const nextVal = Math.round(root.from + ratio * (root.to - root.from));
                    root.moved(nextVal);
                }

                onClicked: mouse => emitAtPos(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        emitAtPos(mouse.x);
                }
                onWheel: wheel => {
                    const step = 5;
                    const delta = wheel.angleDelta.y > 0 ? step : -step;
                    const nextVal = Math.max(root.from, Math.min(root.to, root.value + delta));
                    root.moved(nextVal);
                }
            }
        }

        Text {
            text: root.displayText
            color: root.muted ? Theme.outline : Theme.textOnSurface
            Layout.preferredWidth: 32
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignVCenter
            font {
                family: Config.font.monoFamily
                pixelSize: 11
            }
        }
    }
}
