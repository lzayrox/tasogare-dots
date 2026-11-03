pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../services"

DarkGlassCard {
    id: root

    property string icon: ""
    property string title: ""
    property string subtitle: ""
    property bool active: false

    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 52
    radius: 12
    hovered: mouseArea.containsMouse
    surfaceColor: root.active
        ? Theme.primaryContainer
        : Theme.surfaceVariant
    surfaceAlpha: root.active ? 0.85 : (mouseArea.containsMouse ? 0.55 : 0.40)
    customBorderColor: root.active ? Theme.primary : Theme.outline
    borderAlpha: root.active ? 0.35 : (mouseArea.containsMouse ? 0.24 : 0.14)

    scale: mouseArea.pressed ? 0.96 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter

            AnimatedIcon {
                anchors.centerIn: parent
                text: root.icon
                iconColor: root.active ? Theme.textOnPrimaryContainer : Theme.primary
                iconSize: 18
            }
        }

        ColumnLayout {
            spacing: 1

            Text {
                text: root.title
                color: root.active ? Theme.textOnPrimaryContainer : Theme.textOnSurface
                font {
                    family: Config.font.family
                    pixelSize: 12
                    weight: Font.DemiBold
                }
            }

            Text {
                text: root.subtitle
                color: root.active ? Qt.alpha(Theme.textOnPrimaryContainer, 0.75) : Theme.outline
                font {
                    family: Config.font.family
                    pixelSize: 10
                }
                elide: Text.ElideRight
                Layout.maximumWidth: 85
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
