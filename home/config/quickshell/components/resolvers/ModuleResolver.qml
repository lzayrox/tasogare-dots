pragma ComponentBehavior: Bound

import QtQuick
import "../../modules" as Modules

Item {
    id: root

    Component {
        id: workspacesComp
        Modules.Workspaces {}
    }
    Component {
        id: activeWindowComp
        Modules.ActiveWindow {}
    }
    Component {
        id: clockComp
        Modules.Clock {}
    }
    Component {
        id: networkComp
        Modules.Network {}
    }
    Component {
        id: audioComp
        Modules.Audio {}
    }
    Component {
        id: controlCenterComp
        Modules.ControlCenter {}
    }

    readonly property var modules: ({
        "workspaces": workspacesComp,
        "windowtitle": activeWindowComp,
        "activewindow": activeWindowComp,
        "clock": clockComp,
        "network": networkComp,
        "audio": audioComp,
        "media": audioComp,
        "controlcenter": controlCenterComp
    })

    function getComponent(name) {
        if (!name || name === "none")
            return null;
        const key = String(name).trim().toLowerCase().replace(/[-_]/g, "");
        return root.modules[key] ?? null;
    }
}
