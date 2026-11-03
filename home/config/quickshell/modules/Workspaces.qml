pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../services"

RowLayout {
    id: root

    spacing: Config.bar.itemSpacing

    readonly property var kanjiNumbers: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
    readonly property var romanNumbers: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

    function labelForIndex(idx) {
        const style = Config.workspaces.style;
        if (style === "pills")
            return "";
        if (style === "dots")
            return "•";
        if (style === "numbers")
            return String(idx + 1);
        if (style === "roman")
            return root.romanNumbers[idx] ?? String(idx + 1);
        return root.kanjiNumbers[idx] ?? String(idx + 1);
    }

    Repeater {
        model: Config.workspaces.count

        Rectangle {
            id: wsButton
            required property int index
            readonly property int wsId: index + 1

            readonly property bool isActive: Hypr.isWorkspaceActive(wsId)
            readonly property bool isOccupied: Hypr.isWorkspaceOccupied(wsId)
            readonly property bool isPillStyle: Config.workspaces.style === "pills"

            visible: !Config.workspaces.hideEmpty || isActive || isOccupied

            implicitWidth: isPillStyle
                ? (isActive ? 26 : (isOccupied ? 12 : 8))
                : (label.implicitWidth + 14)
            implicitHeight: isPillStyle ? 8 : 22
            radius: isPillStyle ? height / 2 : Config.bar.radius

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: Config.anim.normal
                    easing.type: Easing.OutCubic
                }
            }

            scale: mouseArea.pressed ? 0.90 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: Config.anim.fast
                    easing.type: Easing.OutCubic
                }
            }

            color: wsButton.isActive
                ? Theme.primary
                : (wsButton.isOccupied ? Theme.surfaceVariant : (wsButton.isPillStyle ? Qt.alpha(Theme.outline, 0.35) : "transparent"))

            Behavior on color {
                ColorAnimation {
                    duration: Config.anim.fast
                }
            }

            Text {
                id: label
                visible: !wsButton.isPillStyle
                anchors.centerIn: parent
                text: root.labelForIndex(wsButton.index)
                color: wsButton.isActive
                    ? Theme.textOnPrimary
                    : (wsButton.isOccupied ? Theme.textOnSurface : Theme.outline)

                font {
                    family: Config.font.monoFamily
                    pixelSize: Config.font.pixelSize
                    weight: wsButton.isActive ? Font.DemiBold : Config.font.weight
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        ShellState.toggle("left");
                    } else {
                        if (wsButton.isActive) {
                            ShellState.toggle("left");
                        } else {
                            Hypr.focusWorkspace(wsButton.wsId);
                        }
                    }
                }
                onWheel: wheel => {
                    if (!Config.workspaces.scrollSwitch)
                        return;
                    const step = wheel.angleDelta.y > 0 ? -1 : 1;
                    const nextWs = Math.max(1, Math.min(Config.workspaces.count, Hypr.activeWorkspaceId + step));
                    if (nextWs !== Hypr.activeWorkspaceId)
                        Hypr.focusWorkspace(nextWs);
                }
            }
        }
    }
}
