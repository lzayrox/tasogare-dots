pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs
import "./components" as Components
import "./services"
import "./utils" as Utils

Variants {
    id: root
    model: Quickshell.screens

    property string position: "top"
    readonly property bool isBottom: root.position === "bottom"
    readonly property bool enabled: isBottom ? Config.bottomBar.enabled : true
    property var otherBar: null
    property var window: null

    Scope {
        id: screenScope
        required property var modelData

        PanelWindow {
            id: barWin
            screen: screenScope.modelData
            visible: root.enabled

            readonly property bool isBarOpen: leftSection.expanded || centerSection.expanded || rightSection.expanded

            Component.onCompleted: root.window = barWin

            HyprlandFocusGrab {
                active: barWin.isBarOpen
                windows: (root.otherBar && root.otherBar.window) ? [ barWin, root.otherBar.window ] : [ barWin ]
                onCleared: ShellState.close()
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: barWin.isBarOpen
                ? WlrKeyboardFocus.OnDemand
                : WlrKeyboardFocus.None
            WlrLayershell.exclusiveZone: (root.isBottom || Hypr.isFullscreen) ? 0 : Config.bar.height
            WlrLayershell.namespace: root.isBottom ? "tasogare-bottom-bar" : "tasogare-bar"
            color: "transparent"

            Shortcut {
                sequence: "Escape"
                enabled: barWin.isBarOpen
                onActivated: ShellState.close()
            }

            anchors {
                top: !root.isBottom
                bottom: root.isBottom
                left: true
                right: true
            }

            margins {
                top: (!root.isBottom && Config.bar.attached) ? 0 : (!root.isBottom ? Config.bar.islandMarginTop : 0)
                bottom: (root.isBottom && Config.bar.attached) ? 0 : (root.isBottom ? Config.bar.islandMarginTop : 0)
                left: (!root.isBottom && !Config.bar.attached) ? Config.bar.margins : 0
                right: (!root.isBottom && !Config.bar.attached) ? Config.bar.margins : 0
            }

            implicitHeight: root.isBottom
                ? (Math.max(500, Math.max(centerSection.expandedHeight, Math.max(leftSection.expandedHeight, rightSection.expandedHeight))) + 30)
                : (Config.bar.islands
                    ? (Math.max(340, Math.max(centerSection.height, Math.max(leftSection.height, Math.max(rightSection.height, Math.max(centerSection.expandedHeight, Math.max(leftSection.expandedHeight, rightSection.expandedHeight)))))) + (Config.bar.attached ? 0 : Config.bar.islandMarginTop) + 24)
                    : (Config.bar.height + (Config.bar.attached ? Config.bar.cornerRadius : 0)))

            mask: Region {
                item: (!root.isBottom && !Hypr.isFullscreen && !Config.bar.islands) ? barBackground : null
                Region {
                    item: (!Hypr.isFullscreen && leftSection.visible && leftSection.width > 0) ? leftSection : null
                }
                Region {
                    item: (!Hypr.isFullscreen && centerSection.visible && centerSection.width > 0) ? centerSection : null
                }
                Region {
                    item: (!Hypr.isFullscreen && rightSection.visible && rightSection.width > 0) ? rightSection : null
                }
            }

            Components.GlassPanel {
                id: barBackground
                visible: !root.isBottom && !Config.bar.islands
                y: Hypr.isFullscreen
                    ? -Config.bar.height
                    : 0
                opacity: Hypr.isFullscreen ? 0.0 : 1.0
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: Config.bar.height
                surfaceAlpha: Config.bar.surfaceAlpha
                radius: Config.bar.cornerRadius
                borderAlpha: Config.bar.borderAlpha
                attached: Config.bar.attached
                attachedEdge: "top"
                flushLeft: true
                flushRight: true
            }

            Item {
                id: barContent
                anchors.fill: parent
                visible: opacity > 0
                opacity: (Hypr.isFullscreen && !barWin.isBarOpen) ? 0.0 : 1.0
                y: (Hypr.isFullscreen && !barWin.isBarOpen)
                    ? (root.isBottom ? (Config.bottomBar.lipHeight + Config.bar.height) : -(Config.bar.height + Config.bar.islandMarginTop))
                    : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.anim.slow
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on y {
                    NumberAnimation {
                        duration: Config.anim.slow
                        easing.type: Easing.OutCubic
                    }
                }

                Components.BarSection {
                    id: leftSection
                    anchors.left: parent.left
                    anchors.top: !root.isBottom ? parent.top : undefined
                    anchors.bottom: root.isBottom ? parent.bottom : undefined
                    anchors.leftMargin: 0
                    attachedPosition: root.position
                    sectionId: root.isBottom ? "bottomLeft" : "left"
                    modules: root.isBottom ? [] : Config.bar.leftModules
                    panel: root.isBottom ? (Config.bottomBar.leftPanel || "workspaces") : Config.bar.leftPanel
                    restingWidth: root.isBottom ? (Config.bottomBar.sideLipWidth || 100) : 0
                    restingHeight: root.isBottom ? (Config.bottomBar.lipHeight || 6) : Config.bar.height
                    islandRadius: root.isBottom ? 6 : Config.bar.cornerRadius
                    adaptCornerLeft: true
                    contentAlignment: "left"
                    hoverExpand: true
                    hoverExpandWidth: true
                    expandable: true
                    animateEntry: !root.isBottom
                    entryDelay: 90
                }

                Components.BarSection {
                    id: centerSection
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: !root.isBottom ? parent.top : undefined
                    anchors.bottom: root.isBottom ? parent.bottom : undefined
                    attachedPosition: root.position
                    sectionId: root.isBottom ? "bottomCenter" : "center"
                    modules: root.isBottom ? [] : Config.bar.centerModules
                    panel: root.isBottom ? (Config.bottomBar.centerPanel || "launcher") : Config.bar.centerPanel
                    restingWidth: root.isBottom ? (Config.bottomBar.lipWidth || 140) : 0
                    restingHeight: root.isBottom ? (Config.bottomBar.lipHeight || 6) : Config.bar.height
                    islandRadius: root.isBottom ? 6 : Config.bar.cornerRadius
                    contentAlignment: "center"
                    hoverExpand: true
                    hoverExpandWidth: true
                    expandable: true
                    animateEntry: !root.isBottom
                    entryDelay: 0
                }

                Components.BarSection {
                    id: rightSection
                    anchors.right: parent.right
                    anchors.top: !root.isBottom ? parent.top : undefined
                    anchors.bottom: root.isBottom ? parent.bottom : undefined
                    anchors.rightMargin: 0
                    attachedPosition: root.position
                    sectionId: root.isBottom ? "bottomRight" : "right"
                    modules: root.isBottom ? [] : Config.bar.rightModules
                    panel: root.isBottom ? (Config.bottomBar.rightPanel || "notifications") : Config.bar.rightPanel
                    restingWidth: root.isBottom ? (Config.bottomBar.sideLipWidth || 100) : 0
                    restingHeight: root.isBottom ? (Config.bottomBar.lipHeight || 6) : Config.bar.height
                    islandRadius: root.isBottom ? 6 : Config.bar.cornerRadius
                    adaptCornerRight: true
                    contentAlignment: "right"
                    hoverExpand: true
                    hoverExpandWidth: true
                    expandable: true
                    animateEntry: !root.isBottom
                    entryDelay: 90
                }
            }
        }
    }
}
