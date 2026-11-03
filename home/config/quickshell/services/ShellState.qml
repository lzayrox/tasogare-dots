pragma Singleton
import Quickshell
import QtQuick
import qs

Singleton {
    id: root

    property string _activeSection: ""
    property string _activePanelOverride: ""

    readonly property string activeSection: _activeSection
    readonly property string activeOverride: _activePanelOverride
    readonly property string activePanelOverride: _activePanelOverride
    readonly property bool isOpen: _activeSection !== ""

    function toggle(target, panelOverride) {
        const sec = normalize(target);
        if (root._activeSection === sec && (!panelOverride || root._activePanelOverride === panelOverride))
            close();
        else
            open(sec, panelOverride);
    }

    function open(target, panelOverride) {
        root._activeSection = normalize(target);
        root._activePanelOverride = panelOverride ? panelOverride : "";
    }

    function close() {
        root._activeSection = "";
        root._activePanelOverride = "";
    }

    function normalize(target) {
        if (!target)
            return "center";
        if (target === "controlCenter" || target === "center")
            return "center";
        return target;
    }

    readonly property bool isTopOpen: isOpen && !activeSection.startsWith("bottom")
    readonly property bool isBottomOpen: isOpen && activeSection.startsWith("bottom")

    function isBottomSection(sectionId) {
        return String(sectionId || "").startsWith("bottom");
    }

    function isTopSection(sectionId) {
        return !isBottomSection(sectionId);
    }

    function panelForSection(sectionId) {
        if (!sectionId)
            return "";

        if (isOpen && activeSection === sectionId && activeOverride !== "")
            return activeOverride;

        switch (sectionId) {
        case "left":
            return Config.bar.leftPanel;
        case "center":
            return Config.bar.centerPanel;
        case "right":
            return Config.bar.rightPanel;
        case "bottomLeft":
            return Config.bottomBar.leftPanel;
        case "bottomCenter":
            return Config.bottomBar.centerPanel;
        case "bottomRight":
            return Config.bottomBar.rightPanel;
        default:
            return "";
        }
    }

    readonly property string currentOpenPanel: isOpen ? panelForSection(activeSection) : ""

    function isSectionExpanded(sectionId) {
        return isOpen && activeSection === sectionId;
    }

    function isPanelOpen(panelName) {
        return isOpen && currentOpenPanel === panelName;
    }

    readonly property bool isLauncherOpen: isPanelOpen("launcher")
    readonly property bool isControlCenterOpen: isPanelOpen("controlCenter")
    readonly property bool isNotificationsOpen: isPanelOpen("notifications")
    readonly property bool isWallpapersOpen: isPanelOpen("wallpapers")
    readonly property bool isWorkspacesOpen: isPanelOpen("workspacesOverview") || isPanelOpen("workspaces")

    readonly property bool isFullscreen: Hypr.isFullscreen
    readonly property int activeWorkspace: (Hypr.activeWorkspace && Hypr.activeWorkspace.id !== undefined) ? Hypr.activeWorkspace.id : 1

    property bool gameMode: false
    property bool privacyMode: false
}
