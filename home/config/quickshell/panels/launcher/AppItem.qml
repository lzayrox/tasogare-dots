pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import "../../components"
import "../../services"

Item {
    id: root

    required property var modelData
    required property int index

    readonly property bool isCurrent: ListView.isCurrentItem

    signal clickedItem(int itemIndex)
    signal activatedItem(int itemIndex)

    width: ListView.view ? ListView.view.width : 500
    height: 46

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: mouseArea.containsMouse && !root.isCurrent
            ? Qt.alpha(Theme.surfaceVariant, 0.35)
            : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Config.anim.fast
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Item {
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 8
                visible: Boolean(root.modelData.isAction)
                color: Qt.alpha(Theme.primaryContainer, 0.65)

                AnimatedIcon {
                    anchors.centerIn: parent
                    text: root.modelData.glyphIcon ?? ""
                    iconColor: Theme.primary
                    iconSize: 16
                }
            }

            IconImage {
                anchors.fill: parent
                visible: !root.modelData.isAction
                asynchronous: true
                source: !root.modelData.isAction
                    ? Quickshell.iconPath(root.modelData.iconName || "application-x-executable", true)
                    : ""
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 1

            Text {
                Layout.fillWidth: true
                text: root.modelData.title ?? ""
                color: root.isCurrent ? Theme.primary : Theme.textOnSurface
                elide: Text.ElideRight
                font {
                    family: Config.font.family
                    pixelSize: 13
                    weight: root.isCurrent ? 600 : 500
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.modelData.subtitle ?? ""
                color: Theme.outline
                elide: Text.ElideRight
                visible: text.length > 0
                font {
                    family: Config.font.family
                    pixelSize: 11
                    weight: 400
                }
            }
        }

        Text {
            visible: root.isCurrent
            text: "↵"
            color: Theme.primary
            Layout.alignment: Qt.AlignVCenter
            font {
                family: Config.font.monoFamily
                pixelSize: 13
                weight: 600
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.clickedItem(root.index)
        onClicked: root.activatedItem(root.index)
    }
}
