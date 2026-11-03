pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../services"

DarkGlassCard {
    id: root

    property string icon: ""
    property int size: 36
    property int iconSize: 15
    property bool danger: false
    property bool subtle: false

    signal clicked()

    implicitWidth: root.size
    implicitHeight: root.size
    radius: root.size / 2
    hovered: mouseArea.containsMouse
    borderAlpha: root.subtle ? 0.0 : (mouseArea.containsMouse ? 0.24 : 0.14)
    surfaceAlpha: root.subtle ? (mouseArea.containsMouse ? 0.5 : 0.0) : (mouseArea.containsMouse ? 0.55 : 0.40)
    surfaceColor: {
        if (root.subtle)
            return Theme.surfaceVariant;
        if (mouseArea.containsMouse)
            return root.danger ? Theme.errorContainer : Qt.lighter(Theme.surfaceVariant, 1.15);
        return Theme.surfaceVariant;
    }

    scale: mouseArea.pressed ? 0.92 : (mouseArea.containsMouse ? 1.05 : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    AnimatedIcon {
        anchors.centerIn: parent
        text: root.icon
        iconColor: {
            if (root.subtle)
                return Theme.outline;
            if (root.danger && mouseArea.containsMouse)
                return Theme.error;
            return Theme.textOnSurface;
        }
        iconSize: root.iconSize
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
