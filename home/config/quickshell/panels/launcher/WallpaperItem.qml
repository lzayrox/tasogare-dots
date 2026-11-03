pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../../components"
import "../../services"

Item {
    id: root

    required property var modelData
    required property int index

    signal selectRequested(int itemIndex)
    signal applyRequested(string filePath)

    readonly property bool isCurrent: PathView.isCurrentItem
    readonly property bool isActiveWall: Theme.currentWallpaper === modelData.path

    width: 264
    height: 186
    z: PathView.itemZ ?? 0 // qmllint disable missing-property
    scale: root.isCurrent ? 1.0 : (root.PathView.onPath ? 0.82 : 0.6)
    opacity: root.PathView.onPath ? (root.isCurrent ? 1.0 : 0.65) : 0.0

    Behavior on scale {
        NumberAnimation {
            duration: Config.anim.normal
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        DarkGlassCard {
            Layout.fillWidth: true
            Layout.preferredHeight: 152
            radius: 14
            customBorderColor: root.isActiveWall
                ? Theme.primary
                : (root.isCurrent ? Theme.tertiary : Theme.outline)
            borderAlpha: root.isActiveWall
                ? 0.90
                : (root.isCurrent ? 0.70 : 0.15)
            surfaceColor: Theme.surfaceVariant
            surfaceAlpha: root.isCurrent ? 0.55 : 0.35

            Image {
                anchors.fill: parent
                anchors.margins: 3
                source: "file://" + root.modelData.path
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize: Qt.size(320, 180)
                clip: true
            }

            Rectangle {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8
                width: 22
                height: 22
                radius: 11
                color: Theme.primary
                visible: root.isActiveWall

                AnimatedIcon {
                    anchors.centerIn: parent
                    text: "✓"
                    iconColor: Theme.textOnPrimary
                    iconSize: 11
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.isCurrent)
                        root.applyRequested(root.modelData.path);
                    else
                        root.selectRequested(root.index);
                }
                onDoubleClicked: root.applyRequested(root.modelData.path)
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.modelData.baseName
            color: root.isCurrent ? Theme.textOnSurface : Theme.outline
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font {
                family: Config.font.family
                pixelSize: 12
                weight: root.isCurrent ? 600 : 500
            }
        }
    }
}
