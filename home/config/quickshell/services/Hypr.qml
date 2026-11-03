pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../utils" as Utils
import qs

Singleton {
    id: root

    readonly property var activeWorkspace: Hyprland.focusedWorkspace
    readonly property int activeWorkspaceId: activeWorkspace ? activeWorkspace.id : 1
    readonly property bool isFullscreen: Boolean(Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.hasFullscreen)

    Connections {
        target: Hyprland.focusedWorkspace

        function onHasFullscreenChanged() {
            if (Hypr.isFullscreen)
                ShellState.close();
        }
    }

    onIsFullscreenChanged: {
        if (isFullscreen)
            ShellState.close();
    }

    readonly property var activeWindow: Hyprland.focusedWindow
    readonly property string windowTitle: activeWindow ? activeWindow.title : ""
    readonly property string windowClass: activeWindow ? activeWindow.clazz : ""

    readonly property string displayTitle: {
        if (!activeWindow || windowTitle.length === 0)
            return "";
        const maxLen = Config.windowTitle.maxLength;
        if (windowTitle.length > maxLen)
            return windowTitle.substring(0, Math.max(1, maxLen - 3)) + "...";
        return windowTitle;
    }

    readonly property string windowIcon: {
        if (!activeWindow)
            return "";

        const c = windowClass.toLowerCase();
        if (c.includes("kitty") || c.includes("terminal") || c.includes("foot") || c.includes("alacritty"))
            return Utils.Icons.appTerminal;
        if (c.includes("firefox") || c.includes("zen") || c.includes("chromium") || c.includes("brave"))
            return Utils.Icons.appBrowser;
        if (c.includes("code") || c.includes("vscodium"))
            return Utils.Icons.appCode;
        if (c.includes("discord") || c.includes("vesktop"))
            return Utils.Icons.appDiscord;
        if (c.includes("spotify"))
            return Utils.Icons.appMusic;
        if (c.includes("steam"))
            return Utils.Icons.appSteam;
        if (c.includes("dolphin") || c.includes("thunar") || c.includes("nemo"))
            return Utils.Icons.appFiles;

        return Utils.Icons.appDefault;
    }

    function isWorkspaceActive(id) {
        return activeWorkspaceId === id;
    }

    function isWorkspaceOccupied(id) {
        // qmllint disable missing-property
        return Hyprland.workspaces.values.some(w => w.id === id);
        // qmllint enable missing-property
    }

    function focusWorkspace(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
    }

    function toggleSpecialWorkspace() {
        Hyprland.dispatch("hl.dsp.workspace.toggle_special(\"magic\")");
        ShellState.close();
    }

    function closeActiveWindow() {
        Hyprland.dispatch("hl.dsp.window.close()");
        ShellState.close();
    }

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            ShellState.close();
        }
    }
}
