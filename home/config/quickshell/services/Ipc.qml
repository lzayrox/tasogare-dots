import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    IpcHandler {
        target: "island"

        function toggle(section: string): void {
            ShellState.toggle(section, "");
        }

        function togglePanel(section: string, panel: string): void {
            ShellState.toggle(section, panel);
        }

        function open(section: string): void {
            ShellState.open(section, "");
        }

        function openPanel(section: string, panel: string): void {
            ShellState.open(section, panel);
        }

        function close(): void {
            ShellState.close();
        }

        function launcher(): void {
            ShellState.toggle("bottomCenter", "launcher");
        }

        function wallpapers(): void {
            ShellState.toggle("bottomCenter", "wallpapers");
        }

        function controlCenter(): void {
            ShellState.toggle("center", "controlCenter");
        }

        function notifications(): void {
            ShellState.toggle("bottomRight", "notifications");
        }

        function workspaces(): void {
            ShellState.toggle("left", "workspaces");
        }
    }

    IpcHandler {
        target: "audio"

        function volumeUp(): void {
            Audio.adjustVolume(5);
        }

        function volumeDown(): void {
            Audio.adjustVolume(-5);
        }

        function setVolume(val: int): void {
            Audio.setVolume(val);
        }

        function mute(): void {
            Audio.toggleMute();
        }

        function micMute(): void {
            Audio.toggleMicMute();
        }
    }

    IpcHandler {
        target: "media"

        function playPause(): void {
            Media.togglePlay();
        }

        function next(): void {
            Media.nextTrack();
        }

        function prev(): void {
            Media.previousTrack();
        }
    }

    IpcHandler {
        target: "theme"

        function toggleMode(): void {
            Theme.mode = (Theme.mode === "dark" ? "light" : "dark");
        }

        function setMode(mode: string): void {
            if (mode === "dark" || mode === "light")
                Theme.mode = mode;
        }

        function setWallpaper(path: string): void {
            Theme.apply(path);
        }

        function setSeed(index: int): void {
            Theme.sourceColorIndex = Math.max(0, Math.min(3, index));
        }
    }

    IpcHandler {
        target: "notifs"

        function toggleDnd(): void {
            Notifs.toggleDnd();
        }

        function clear(): void {
            Notifs.clearAll();
        }
    }
}
