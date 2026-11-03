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

    readonly property string targetBar: Config.osd.notifications.position.bar
    readonly property string targetSection: Config.osd.notifications.position.section
    readonly property bool osdActive: Config.osd.enabled && Config.osd.notifications.enabled && Notifs.popupCount > 0
    readonly property double lastTriggeredAt: Notifs.lastPopupAt
    implicitWidth: Config.osd.notifications.width
    readonly property real panelHeight: Math.max(Config.osd.notifications.minHeight, popupColumn.implicitHeight + 24)
    implicitHeight: panelHeight

    ColumnLayout {
        id: popupColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Repeater {
            model: Notifs.popups

            DarkGlassCard {
                id: toastCard
                required property var modelData

                readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical

                Layout.fillWidth: true
                implicitHeight: cardLayout.implicitHeight + 20
                radius: 12
                surfaceColor: isCritical ? Theme.errorContainer : Theme.surfaceContainer
                surfaceAlpha: isCritical ? 0.65 : 0.38

                ColumnLayout {
                    id: cardLayout
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 34
                            Layout.preferredHeight: 34
                            Layout.alignment: Qt.AlignTop
                            radius: 10
                            color: toastCard.isCritical
                                ? Qt.alpha(Theme.error, 0.25)
                                : Qt.alpha(Theme.primaryContainer, 0.65)

                            IconImage {
                                anchors.fill: parent
                                anchors.margins: 5
                                visible: Boolean(toastCard.modelData.appIcon && toastCard.modelData.appIcon.length > 0)
                                asynchronous: true
                                source: (toastCard.modelData.appIcon && toastCard.modelData.appIcon.length > 0)
                                    ? Quickshell.iconPath(toastCard.modelData.appIcon, true)
                                    : ""
                            }

                            AnimatedIcon {
                                anchors.centerIn: parent
                                visible: !toastCard.modelData.appIcon || toastCard.modelData.appIcon.length === 0
                                text: Utils.Icons.bell
                                iconColor: toastCard.isCritical ? Theme.error : Theme.primary
                                iconSize: 16
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
                                    text: toastCard.modelData.summary
                                    color: toastCard.isCritical ? Theme.textOnErrorContainer : Theme.textOnSurface
                                    elide: Text.ElideRight
                                    font {
                                        family: Config.font.family
                                        pixelSize: 13
                                        weight: 600
                                    }
                                }

                                Text {
                                    text: toastCard.modelData.appName
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
                                visible: Boolean(toastCard.modelData.body && toastCard.modelData.body.length > 0)
                                text: toastCard.modelData.body
                                color: toastCard.isCritical ? Theme.textOnErrorContainer : Theme.textOnSurfaceVariant
                                wrapMode: Text.Wrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                                font {
                                    family: Config.font.family
                                    pixelSize: 12
                                    weight: 400
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: Boolean(toastCard.modelData.actions && toastCard.modelData.actions.length > 0)
                        spacing: 6

                        Repeater {
                            model: toastCard.modelData.actions

                            DarkGlassCard {
                                id: actBtn
                                required property var modelData

                                Layout.fillWidth: true
                                implicitHeight: 26
                                radius: 8
                                surfaceColor: Theme.primaryContainer
                                surfaceAlpha: 0.65

                                Text {
                                    anchors.centerIn: parent
                                    text: actBtn.modelData.text || "Acción"
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
                                        actBtn.modelData.invoke();
                                        Notifs.dismissPopup(toastCard.modelData.id);
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton)
                            Notifs.dismiss(toastCard.modelData.id);
                        else
                            Notifs.dismissPopup(toastCard.modelData.id);
                    }
                }
            }
        }
    }
}
