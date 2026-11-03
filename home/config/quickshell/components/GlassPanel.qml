pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../services"

Rectangle {
    id: root

    default property alias content: contentContainer.data

    property color surfaceColor: Theme.background
    property real surfaceAlpha: 0.75
    property color customBorderColor: Theme.outline
    property real borderAlpha: 0.12
    property real contentMargin: 0

    property bool attached: false
    property string attachedEdge: "top"
    property int attachedCornerRadius: Config.bar.cornerRadius
    property bool flushLeft: false
    property bool flushRight: false

    readonly property bool isBottomAttached: attached && attachedEdge === "bottom"
    readonly property bool isTopAttached: attached && attachedEdge !== "bottom"

    radius: Config.bar.radius ?? 12
    topLeftRadius: isTopAttached ? 0 : (isBottomAttached && flushLeft ? 0 : radius)
    topRightRadius: isTopAttached ? 0 : (isBottomAttached && flushRight ? 0 : radius)
    bottomLeftRadius: isBottomAttached ? 0 : (isTopAttached && flushLeft ? 0 : radius)
    bottomRightRadius: isBottomAttached ? 0 : (isTopAttached && flushRight ? 0 : radius)

    color: Qt.alpha(surfaceColor, surfaceAlpha)

    Behavior on color {
        ColorAnimation {
            duration: Config.anim.normal
            easing.type: Easing.OutCubic
        }
    }

    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: root.contentMargin
    }
}
