pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"
import "../utils" as Utils

Item {
    id: root

    implicitWidth: Config.panels.workspacesOverview.width
    readonly property real panelHeight: Config.panels.workspacesOverview.height
    implicitHeight: panelHeight

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: Config.workspaces.count

                DarkGlassCard {
                    id: wsCard
                    required property int index
                    readonly property int wsId: index + 1
                    readonly property bool isActive: Hypr.isWorkspaceActive(wsId)
                    readonly property bool isOccupied: Hypr.isWorkspaceOccupied(wsId)

                    Layout.fillWidth: true
                    implicitHeight: 48
                    radius: 10

                    surfaceColor: wsCard.isActive ? Theme.primaryContainer : Theme.surfaceVariant
                    surfaceAlpha: wsCard.isActive ? 0.85 : (mouseArea.containsMouse ? 0.55 : 0.35)

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            text: String(wsCard.wsId)
                            color: wsCard.isActive ? Theme.textOnPrimaryContainer : Theme.textOnSurface
                            Layout.alignment: Qt.AlignHCenter
                            font {
                                family: Config.font.family
                                pixelSize: 14
                                weight: wsCard.isActive ? 700 : 500
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: wsCard.isActive ? 16 : (wsCard.isOccupied ? 6 : 0)
                            height: 3
                            radius: 1.5
                            color: wsCard.isActive ? Theme.primary : Theme.outline
                            visible: wsCard.isActive || wsCard.isOccupied
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hypr.focusWorkspace(wsCard.wsId);
                            ShellState.close();
                        }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            QuickToggle {
                icon: Utils.Icons.workspaces
                title: "Espacio Especial"
                subtitle: "Scratchpad"
                active: false
                onClicked: Hypr.toggleSpecialWorkspace()
            }

            QuickToggle {
                icon: Utils.Icons.power
                title: "Cerrar Ventana"
                subtitle: Hypr.windowClass.length > 0 ? Hypr.windowClass : "Ninguna"
                active: false
                onClicked: Hypr.closeActiveWindow()
            }
        }
    }
}
