pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../components" as Components
import "./resolvers" as Resolvers
import "../services"

Components.GlassPanel {
    id: root

    property var modules: []
    property bool isIslands: Config.bar.islands
    property bool isAttached: Config.bar.attached
    property real islandRadius: 0
    property bool animateEntry: false
    property int entryDelay: 0
    property real entryY: root.animateEntry ? (root.isBottomAttached ? 50 : -50) : 0
    property real entryOpacity: root.animateEntry ? 0.0 : 1.0
    property bool hoverExpand: false
    property bool hoverExpandWidth: true
    property string contentAlignment: "center"
    property string attachedPosition: Config.bar.position
    readonly property bool isBottomAttached: attachedPosition === "bottom"
    readonly property bool isTopAttached: attachedPosition !== "bottom"

    property real restingHeight: Config.bar.height
    property real restingWidth: 0

    property string sectionId: "center"
    property string panel: ""
    readonly property string currentPanel: ShellState.panelForSection(root.sectionId) || root.panel

    property bool expandable: Boolean(root.currentPanel && root.currentPanel !== "none")
    property real expandedWidth: (root.expanded && viewLoader.item && viewLoader.item.implicitWidth > 0)
        ? viewLoader.item.implicitWidth
        : 360
    property real expandedHeight: (root.expanded && viewLoader.item && viewLoader.item.panelHeight > 0)
        ? viewLoader.item.panelHeight
        : 305
    readonly property bool osdShowing: !root.expanded && osdResolver.osdActive
    readonly property bool isMorphed: root.expanded || root.osdShowing
    readonly property real osdWidth: osdResolver.targetWidth
    readonly property real osdHeight: osdResolver.targetHeight
    property real expandedRadius: 20
    readonly property bool expanded: root.expandable && ShellState.isSectionExpanded(root.sectionId)
    z: root.expanded ? 10 : (root.osdShowing ? 8 : 1)
    readonly property real hoverTextScreenMargin: Math.round(((Config.bar.height + (root.hoverExpand ? 12 : 0)) - Config.font.pixelSize) / 2)

    property real baseFillet: Config.bar.cornerRadius
    property real expandedFilletX: 4.5
    property real expandedFilletY: 18.0

    readonly property real hoverFilletX: (root.hoverExpand && hoverHandler.hovered && !root.isMorphed) ? -1.5 : 0
    readonly property real hoverFilletY: (root.hoverExpand && hoverHandler.hovered && !root.isMorphed) ? 4.0 : 0

    readonly property real targetFilletX: root.isMorphed ? root.expandedFilletX : (root.baseFillet + root.hoverFilletX)
    readonly property real targetFilletY: root.isMorphed ? root.expandedFilletY : (root.baseFillet + root.hoverFilletY)

    property real currentFilletX: root.targetFilletX
    property real currentFilletY: root.targetFilletY

    readonly property int morphDuration: root.isMorphed ? Config.anim.slow : (hoverHandler.hovered ? Config.anim.morph : Config.anim.normal)
    readonly property int morphEasing: root.isMorphed ? Easing.OutQuart : Easing.OutCubic

    Behavior on currentFilletX {
        NumberAnimation {
            duration: root.morphDuration
            easing.type: root.morphEasing
        }
    }

    Behavior on currentFilletY {
        NumberAnimation {
            duration: root.morphDuration
            easing.type: root.morphEasing
        }
    }

    property bool adaptCornerLeft: false
    property bool adaptCornerRight: false
    property real edgeDistance: (root.adaptCornerLeft || root.adaptCornerRight) ? 0 : 999

    readonly property real adaptProgress: {
        const threshold = 32.0;
        if (root.edgeDistance >= threshold)
            return 0.0;
        if (root.edgeDistance <= 0.0)
            return 1.0;
        const p = 1.0 - (root.edgeDistance / threshold);
        return p * p * (3.0 - 2.0 * p);
    }

    readonly property real radiusBottomLeft: root.adaptCornerLeft ? ((1.0 - root.adaptProgress) * root.radius) : root.radius

    readonly property real radiusBottomRight: root.adaptCornerRight ? ((1.0 - root.adaptProgress) * root.radius) : root.radius

    readonly property real filletLeftX: root.adaptCornerLeft ? ((1.0 - root.adaptProgress) * root.currentFilletX) : root.currentFilletX

    readonly property real filletRightX: root.adaptCornerRight ? ((1.0 - root.adaptProgress) * root.currentFilletX) : root.currentFilletX

    property real lastContentWidth: 0

    readonly property bool hasModules: Boolean(root.modules && root.modules.length > 0)
    readonly property bool hasContent: (root.hasModules && (row.implicitWidth > 0 || root.lastContentWidth > 0)) || root.isMorphed || root.panel !== "" || root.restingWidth > 0
    readonly property bool isUnifiedIsland: isIslands && isAttached

    visible: root.hasModules || root.panel !== "" || osdResolver.hasAssignedOsd || root.restingWidth > 0
    opacity: (root.hasContent ? 1.0 : 0.0) * root.entryOpacity

    readonly property real baseContentWidth: Math.max(row.implicitWidth, root.lastContentWidth)
    property real contentWidth: root.hasContent ? root.baseContentWidth : 0

    readonly property real hoverExtraWidth: (root.hoverExpand && root.hoverExpandWidth && hoverHandler.hovered && !root.isMorphed) ? 36 : 0
    readonly property real hoverExtraHeight: (root.hoverExpand && hoverHandler.hovered && !root.isMorphed) ? (root.isBottomAttached ? 6 : 12) : 0

    height: root.expanded ? root.expandedHeight : (root.osdShowing ? root.osdHeight : (root.hasContent ? (root.restingHeight + root.hoverExtraHeight) : 0))
    implicitHeight: root.height
    implicitWidth: root.expanded
        ? root.expandedWidth
        : (root.osdShowing
            ? root.osdWidth
            : (root.restingWidth > 0
                ? (root.restingWidth + (root.hoverExpand && root.hoverExpandWidth ? root.hoverExtraWidth : 0))
                : (root.hasContent ? (root.baseContentWidth + (root.isIslands ? (28 + root.hoverExtraWidth) : 0)) : 0)))
    width: root.implicitWidth
    radius: root.isMorphed ? root.expandedRadius : root.islandRadius
    surfaceAlpha: (root.isIslands && !root.isUnifiedIsland) ? Config.bar.surfaceAlpha : 0.0
    borderAlpha: root.isIslands ? Config.bar.borderAlpha : 0.0
    attached: root.hasContent && root.isIslands && root.isAttached && !root.isUnifiedIsland
    attachedEdge: root.attachedPosition

    HoverHandler {
        id: hoverHandler
        enabled: root.hoverExpand && !root.isMorphed
    }

    transform: Translate {
        id: entryTranslate
        y: root.entryY
    }

    ParallelAnimation {
        id: entryAnim

        NumberAnimation {
            target: root
            property: "entryY"
            from: root.isBottomAttached ? 50 : -50
            to: 0
            duration: 420
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root
            property: "entryOpacity"
            from: 0.0
            to: 1.0
            duration: 100
            easing.type: Easing.OutCubic
        }

        onFinished: {
            root.animateEntry = false;
            root.entryY = 0;
            root.entryOpacity = 1.0;
        }
    }

    Timer {
        id: entryTimer
        interval: root.entryDelay
        running: false
        repeat: false
        onTriggered: entryAnim.start()
    }

    Component.onCompleted: {
        if (!root.animateEntry || !root.isIslands) {
            root.entryY = 0;
            root.entryOpacity = 1.0;
            return;
        }

        if (root.entryDelay > 0)
            entryTimer.start();
        else
            entryAnim.start();
    }

    Behavior on height {
        enabled: !root.animateEntry
        NumberAnimation {
            duration: root.morphDuration
            easing.type: root.morphEasing
        }
    }

    Behavior on implicitWidth {
        enabled: !root.animateEntry
        NumberAnimation {
            duration: root.morphDuration
            easing.type: root.morphEasing
        }
    }

    Behavior on radius {
        enabled: !root.animateEntry
        NumberAnimation {
            duration: root.morphDuration
            easing.type: root.morphEasing
        }
    }

    Behavior on opacity {
        enabled: !root.animateEntry
        NumberAnimation {
            duration: Config.anim.fast
            easing.type: Easing.OutCubic
        }
    }

    IslandCanvas {
        id: islandCanvas
        visible: root.isUnifiedIsland && root.hasContent && root.opacity > 0
        anchors.top: !root.isBottomAttached ? parent.top : undefined
        anchors.bottom: root.isBottomAttached ? parent.bottom : undefined
        bodyWidth: root.width
        bodyHeight: root.height
        radiusBottomLeft: root.radiusBottomLeft
        radiusBottomRight: root.radiusBottomRight
        filletLeftX: root.filletLeftX
        filletRightX: root.filletRightX
        filletY: root.currentFilletY
        isBottomAttached: root.isBottomAttached
    }

    MouseArea {
        id: islandMouseArea
        anchors.fill: parent
        enabled: root.expandable || root.expanded
        cursorShape: !root.expanded ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if (!root.expanded)
                ShellState.toggle(root.sectionId);
        }
    }

    Resolvers.ModuleResolver {
        id: resolver
    }

    Resolvers.PanelResolver {
        id: panelResolver
    }

    Item {
        id: barArea
        anchors.top: !root.isBottomAttached ? parent.top : undefined
        anchors.bottom: root.isBottomAttached ? parent.bottom : undefined
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: root.isMorphed ? root.restingHeight : root.height
        clip: true

        Rectangle {
            anchors.centerIn: parent
            visible: !root.isMorphed && (!root.modules || root.modules.length === 0)
            width: 36
            height: 3
            radius: 1.5
            color: Qt.alpha(Theme.textOnSurface, hoverHandler.hovered ? 0.70 : 0.35)
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.expandable && root.expanded
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton
            onClicked: ShellState.close()
        }

        RowLayout {
            id: row
            anchors.left: root.contentAlignment === "left" ? parent.left : undefined
            anchors.leftMargin: root.contentAlignment === "left" ? (root.isIslands ? 14 : 0) : 0
            anchors.right: root.contentAlignment === "right" ? parent.right : undefined
            anchors.rightMargin: root.contentAlignment === "right" ? (root.isIslands ? 14 : 0) : 0
            anchors.horizontalCenter: root.contentAlignment === "center" ? parent.horizontalCenter : undefined
            anchors.verticalCenter: parent.verticalCenter
            spacing: Config.bar.moduleSpacing
            opacity: root.isMorphed ? 0.0 : 1.0
            enabled: !root.isMorphed

            onImplicitWidthChanged: {
                if (row.implicitWidth > 0)
                    root.lastContentWidth = row.implicitWidth;
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: root.isMorphed ? 180 : 260
                    easing.type: Easing.OutCubic
                }
            }

            Repeater {
                model: root.modules

                Loader {
                    required property string modelData
                    sourceComponent: resolver.getComponent(modelData)
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: (item && item.visible) ? item.implicitWidth : 0
                    Layout.preferredHeight: (item && item.visible) ? item.implicitHeight : 0
                }
            }
        }
    }

    Item {
        id: osdContainer
        anchors.fill: parent
        clip: true
        anchors.topMargin: 12
        anchors.bottomMargin: 12
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        opacity: root.osdShowing ? 1.0 : 0.0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: root.osdShowing ? Config.anim.fast : Config.anim.normal
                easing.type: Easing.OutCubic
            }
        }

        Resolvers.OsdResolver {
            id: osdResolver
            anchors.fill: parent
            barName: root.isBottomAttached ? "bottom" : "top"
            sectionName: root.contentAlignment
        }
    }

    Item {
        id: expandedContainer
        anchors.fill: parent
        clip: true
        anchors.topMargin: !root.isBottomAttached ? (root.isAttached ? root.hoverTextScreenMargin : 12) : 12
        anchors.bottomMargin: root.isBottomAttached ? (root.isAttached ? root.hoverTextScreenMargin : 14) : 14
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        opacity: root.expanded ? 1.0 : 0.0
        visible: opacity > 0

        transform: Translate {
            y: root.expanded ? 0 : (root.isBottomAttached ? Math.round(Config.bar.height / 2) : -Math.round(Config.bar.height / 2))

            Behavior on y {
                NumberAnimation {
                    duration: Config.anim.morph
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.expanded ? Config.anim.normal : Config.anim.morph
                easing.type: Easing.OutCubic
            }
        }

        Loader {
            id: viewLoader
            anchors.fill: parent
            active: root.expanded || expandedContainer.opacity > 0
            sourceComponent: panelResolver.getComponent(root.currentPanel)
        }
    }
}
