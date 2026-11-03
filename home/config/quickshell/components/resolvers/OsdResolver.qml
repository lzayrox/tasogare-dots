pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../../osd" as Osds

Item {
    id: root

    property string barName: "bottom"
    property string sectionName: "right"

    readonly property bool volMatches: volOsd.targetBar === root.barName && volOsd.targetSection === root.sectionName
    readonly property bool notifsMatches: notifsOsd.targetBar === root.barName && notifsOsd.targetSection === root.sectionName

    readonly property bool volActive: root.volMatches && volOsd.osdActive
    readonly property bool notifsActive: root.notifsMatches && notifsOsd.osdActive

    readonly property var currentOsd: {
        if (root.volActive && root.notifsActive)
            return (volOsd.lastTriggeredAt >= notifsOsd.lastTriggeredAt) ? volOsd : notifsOsd;
        if (root.volActive)
            return volOsd;
        if (root.notifsActive)
            return notifsOsd;
        return null;
    }

    readonly property bool hasAssignedOsd: root.volMatches || root.notifsMatches
    readonly property bool osdActive: root.currentOsd !== null
    readonly property real targetWidth: root.currentOsd ? (root.currentOsd.implicitWidth + 28) : 300
    readonly property real targetHeight: root.currentOsd ? root.currentOsd.panelHeight : 64

    Osds.Volume {
        id: volOsd
        anchors.fill: parent
        opacity: root.currentOsd === volOsd ? 1.0 : 0.0
        visible: opacity > 0
        enabled: root.currentOsd === volOsd

        Behavior on opacity {
            NumberAnimation {
                duration: Config.anim.fast
                easing.type: Easing.OutCubic
            }
        }
    }

    Osds.Notifications {
        id: notifsOsd
        anchors.fill: parent
        opacity: root.currentOsd === notifsOsd ? 1.0 : 0.0
        visible: opacity > 0
        enabled: root.currentOsd === notifsOsd

        Behavior on opacity {
            NumberAnimation {
                duration: Config.anim.fast
                easing.type: Easing.OutCubic
            }
        }
    }
}
