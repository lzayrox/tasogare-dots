pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs
import "../components"
import "../services"
import "../utils" as Utils

Item {
    id: root

    implicitWidth: Config.panels.notifications.width
    readonly property real panelHeight: Config.panels.notifications.height
    implicitHeight: panelHeight

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            QuickToggle {
                Layout.fillWidth: true
                icon: Notifs.dnd ? Utils.Icons.bellOff : Utils.Icons.bell
                title: Notifs.dnd ? "No Molestar" : "Alertas Activas"
                subtitle: Notifs.count > 0 ? (Notifs.count + " en historial") : "Sin pendientes"
                active: Notifs.dnd
                onClicked: Notifs.toggleDnd()
            }

            IconButton {
                visible: Notifs.count > 0
                icon: Utils.Icons.trash
                danger: true
                onClicked: Notifs.clearAll()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            DarkGlassCard {
                anchors.fill: parent
                visible: Notifs.count === 0
                radius: 12
                surfaceColor: Theme.surfaceVariant
                surfaceAlpha: 0.35

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    AnimatedIcon {
                        Layout.alignment: Qt.AlignHCenter
                        text: Notifs.dnd ? Utils.Icons.bellOff : Utils.Icons.bell
                        iconColor: Theme.outline
                        iconSize: 24
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Sin notificaciones pendientes"
                        color: Theme.textOnSurface
                        font {
                            family: Config.font.family
                            pixelSize: 13
                            weight: 600
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Notifs.dnd ? "Modo No Molestar activado" : "Todo está al día"
                        color: Theme.outline
                        font {
                            family: Config.font.family
                            pixelSize: 11
                        }
                    }
                }
            }

            ListView {
                id: notifListView
                anchors.fill: parent
                visible: Notifs.count > 0
                model: Notifs.list
                spacing: 8
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                delegate: DarkGlassCard {
                    id: itemCard
                    required property var modelData

                    readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical

                    width: notifListView.width
                    implicitHeight: itemInner.implicitHeight + 20
                    radius: 12
                    surfaceColor: isCritical ? Theme.errorContainer : Theme.surfaceVariant
                    surfaceAlpha: mouseArea.containsMouse ? 0.60 : 0.42
                    customBorderColor: isCritical ? Theme.error : Theme.outline
                    borderAlpha: isCritical ? 0.55 : 0.15

                    ColumnLayout {
                        id: itemInner
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                Layout.alignment: Qt.AlignTop
                                radius: 8
                                color: itemCard.isCritical
                                    ? Qt.alpha(Theme.error, 0.25)
                                    : Qt.alpha(Theme.primaryContainer, 0.60)

                                IconImage {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    visible: Boolean(itemCard.modelData.appIcon && itemCard.modelData.appIcon.length > 0)
                                    asynchronous: true
                                    source: (itemCard.modelData.appIcon && itemCard.modelData.appIcon.length > 0)
                                        ? Quickshell.iconPath(itemCard.modelData.appIcon, true)
                                        : ""
                                }

                                AnimatedIcon {
                                    anchors.centerIn: parent
                                    visible: !itemCard.modelData.appIcon || itemCard.modelData.appIcon.length === 0
                                    text: Utils.Icons.bell
                                    iconColor: itemCard.isCritical ? Theme.error : Theme.primary
                                    iconSize: 14
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: itemCard.modelData.summary
                                        color: itemCard.isCritical ? Theme.textOnErrorContainer : Theme.textOnSurface
                                        elide: Text.ElideRight
                                        font {
                                            family: Config.font.family
                                            pixelSize: 12
                                            weight: 600
                                        }
                                    }

                                    Text {
                                        text: itemCard.modelData.appName + " • " + itemCard.modelData.time
                                        color: Theme.outline
                                        font {
                                            family: Config.font.family
                                            pixelSize: 10
                                            weight: 500
                                        }
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: Boolean(itemCard.modelData.body && itemCard.modelData.body.length > 0)
                                    text: itemCard.modelData.body
                                    color: itemCard.isCritical ? Theme.textOnErrorContainer : Theme.textOnSurfaceVariant
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                    font {
                                        family: Config.font.family
                                        pixelSize: 11
                                        weight: 400
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            visible: Boolean(itemCard.modelData.actions && itemCard.modelData.actions.length > 0)
                            spacing: 6

                            Repeater {
                                model: itemCard.modelData.actions

                                DarkGlassCard {
                                    id: histActBtn
                                    required property var modelData

                                    Layout.fillWidth: true
                                    implicitHeight: 26
                                    radius: 7
                                    surfaceColor: Theme.primaryContainer
                                    surfaceAlpha: 0.65

                                    Text {
                                        anchors.centerIn: parent
                                        text: histActBtn.modelData.text || "Acción"
                                        color: Theme.textOnPrimaryContainer
                                        elide: Text.ElideRight
                                        font {
                                            family: Config.font.family
                                            pixelSize: 11
                                            weight: 600
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            histActBtn.modelData.invoke();
                                            Notifs.dismiss(itemCard.modelData.id);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        z: -1
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Notifs.dismiss(itemCard.modelData.id)
                    }
                }
            }
        }
    }
}
