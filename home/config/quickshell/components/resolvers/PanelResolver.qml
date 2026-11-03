pragma ComponentBehavior: Bound

import QtQuick
import "../../panels" as Panels

Item {
    id: root

    Component {
        id: controlCenterComp
        Panels.ControlCenter {}
    }
    Component {
        id: workspacesOverviewComp
        Panels.WorkspacesOverview {}
    }
    Component {
        id: statusDetailsComp
        Panels.StatusDetails {}
    }
    Component {
        id: launcherComp
        Panels.Launcher {}
    }
    Component {
        id: notificationsComp
        Panels.Notifications {}
    }

    readonly property var panels: ({
        "controlcenter": controlCenterComp,
        "workspaces": workspacesOverviewComp,
        "workspacesoverview": workspacesOverviewComp,
        "status": statusDetailsComp,
        "statusdetails": statusDetailsComp,
        "launcher": launcherComp,
        "wallpapers": launcherComp,
        "notifications": notificationsComp
    })

    function getComponent(name) {
        if (!name || name === "none")
            return null;
        const key = String(name).trim().toLowerCase().replace(/[-_]/g, "");
        return root.panels[key] ?? null;
    }
}
