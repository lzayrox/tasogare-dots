pragma ComponentBehavior: Bound

import QtQuick
import qs

QtObject {
    id: root

    required property real screenWidth
    required property real windowHeight
    required property real leftContentWidth
    required property real centerContentWidth
    required property real rightContentWidth

    readonly property bool isBottom: Config.bar.position === "bottom"
    readonly property bool isAttached: Config.bar.attached
    readonly property bool isIslands: Config.bar.islands

    readonly property real maxSideWidth: (root.leftContentWidth > 0 || root.rightContentWidth > 0)
        ? (Math.max(root.leftContentWidth, root.rightContentWidth) + (root.isIslands ? 28 : 16))
        : 0
    readonly property real centerTargetWidth: root.centerContentWidth > 0
        ? (root.centerContentWidth + (root.isIslands ? 32 : 0))
        : 0
    readonly property real minBarWidth: {
        const sideTotal = (root.leftContentWidth > 0 && root.rightContentWidth > 0)
            ? (root.maxSideWidth * 2)
            : (root.leftContentWidth > 0 || root.rightContentWidth > 0 ? root.maxSideWidth : 0);
        const padding = (root.isIslands && root.isAttached && (root.leftContentWidth > 0 || root.rightContentWidth > 0) && root.centerContentWidth > 0)
            ? (Config.bar.cornerRadius * 4 + 24)
            : 48;
        return sideTotal + root.centerTargetWidth + padding;
    }

    readonly property real targetBarWidth: Config.bar.width <= 0
        ? root.screenWidth
        : (Config.bar.width <= 100
            ? Math.round(root.screenWidth * (Config.bar.width / 100.0))
            : Config.bar.width)

    readonly property real resolvedWidth: Math.max(root.minBarWidth, Math.min(root.screenWidth, root.targetBarWidth))
    readonly property bool isFullWidth: root.resolvedWidth >= root.screenWidth - 1

    readonly property real barEdgeY: root.isBottom ? (root.windowHeight - Config.bar.cornerRadius) : 0
    readonly property real belowBarY: root.isBottom ? 0 : Config.bar.height
    readonly property real islandRadius: !root.isIslands
        ? 0
        : (root.isAttached ? Config.bar.cornerRadius : Config.bar.height / 2)
}
