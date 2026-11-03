pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../services"

Rectangle {
    id: root

    property string icon: ""
    property string text: ""
    
    property color iconColor: Theme.primary
    property color textColor: Theme.textOnSurface
    property color bgNormalColor: "transparent"

    property bool clickable: true
    property int acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    signal clicked(var mouse)
    signal scrolled(var wheel)

    implicitWidth: layout.implicitWidth + (Config.bar.itemSpacing * 2)
    implicitHeight: Math.max(24, layout.implicitHeight + 6)
    radius: height / 2

    color: bgNormalColor

    scale: mouseArea.pressed && root.clickable ? 0.95 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Config.bar.itemSpacing

        AnimatedIcon {
            visible: root.icon.length > 0
            text: root.icon
            iconColor: root.iconColor
            iconSize: Config.font.pixelSize
        }

        Text {
            visible: root.text.length > 0
            text: root.text
            color: root.textColor

            font {
                family: Config.font.monoFamily
                pixelSize: Config.font.pixelSize
                weight: Config.font.weight
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.clickable
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: root.acceptedButtons

        onClicked: mouse => {
            if (root.clickable)
                root.clicked(mouse);
        }

        onWheel: wheel => {
            root.scrolled(wheel);
        }
    }
}
