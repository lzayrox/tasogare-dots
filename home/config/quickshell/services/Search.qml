pragma Singleton
import Quickshell
import QtQuick
import "../utils" as Utils

Singleton {
    id: root

    property string query: ""

    readonly property string normalizedInput: String(root.query || "").replace(/^\s+/, "")

    readonly property string mode: {
        const lower = root.normalizedInput.toLowerCase();
        if (lower.startsWith(">wallpaper") || lower.startsWith(">wp") || lower.startsWith(":wallpaper") || lower.startsWith(":wp"))
            return "wallpapers";
        if (lower.startsWith(">") || lower.startsWith(":"))
            return "actions";
        return "apps";
    }

    readonly property bool isWallpaperMode: root.mode === "wallpapers"

    readonly property string subQuery: {
        if (root.mode === "wallpapers") {
            const spaceIdx = root.normalizedInput.indexOf(" ");
            return spaceIdx >= 0 ? root.normalizedInput.slice(spaceIdx + 1).trim() : "";
        }
        if (root.mode === "actions")
            return root.normalizedInput.slice(1).trim();
        return root.normalizedInput.trim();
    }

    readonly property var dailyDriverKeywords: [
        "kitty", "zen", "firefox", "code", "visual studio code", "vscodium",
        "antigravity", "neovim", "nvim", "dolphin", "thunar", "nautilus",
        "vesktop", "discord", "obsidian", "spotify", "telegram", "alacritty",
        "wezterm", "ghostty", "brave", "chromium"
    ]

    readonly property var gameKeywords: [
        "steam_app_", "play this game on steam", "proton", "steam linux runtime",
        "lutris", "heroic", "prismlauncher", "minecraft", "retroarch",
        "gamescope", "mangohud", "wine"
    ]

    readonly property var lowPriorityHelpers: [
        "avahi", "qt5ct", "qt6ct", "kvantum", "fcitx", "ibus",
        "cmake-gui", "nixos-manual", "winetricks", "lsp-plugins"
    ]

    function hasWordOrId(haystack, keyword) {
        if (!haystack || !keyword)
            return false;
        return haystack.includes(keyword);
    }

    function computeBasePriority(app) {
        const id = String(app.id || "").toLowerCase();
        const name = String(app.name || "").toLowerCase();
        const generic = String(app.genericName || "").toLowerCase();
        const comment = String(app.comment || "").toLowerCase();
        const cats = app.categories ? String(app.categories).toLowerCase() : "";
        const combined = id + " " + name + " " + generic + " " + comment + " " + cats;

        if (id.startsWith("steam_app_") || comment.includes("play this game on steam") || name.startsWith("proton ") || name.includes("steam linux runtime"))
            return -40;

        if (cats.includes("game"))
            return -30;

        for (let i = 0; i < root.gameKeywords.length; ++i) {
            if (root.hasWordOrId(combined, root.gameKeywords[i]))
                return -30;
        }

        if (id.includes("steam") || name === "steam")
            return -25;

        for (let i = 0; i < root.dailyDriverKeywords.length; ++i) {
            const kw = root.dailyDriverKeywords[i];
            if (id.includes(kw) || name === kw || name.startsWith(kw + " ") || name.endsWith(" " + kw))
                return 45;
        }

        for (let i = 0; i < root.lowPriorityHelpers.length; ++i) {
            if (root.hasWordOrId(combined, root.lowPriorityHelpers[i]))
                return -10;
        }

        if (cats.includes("terminalemulator") || cats.includes("webbrowser") || cats.includes("filemanager") || cats.includes("ide") || cats.includes("texteditor") || cats.includes("development"))
            return 30;

        if (cats.includes("office") || cats.includes("audiovideo") || cats.includes("graphics"))
            return 20;

        return 10;
    }

    readonly property var actionEntries: [
        {
            isAction: true,
            actionType: "wallpaper",
            glyphIcon: Utils.Icons.controlCenter,
            iconName: "",
            title: "Wallpapers y Tema",
            subtitle: ">wallpaper  •  Cambiar fondo y paleta Matugen",
            basePriority: 25,
            entry: null,
            cmd: []
        },
        {
            isAction: true,
            actionType: "toggleTheme",
            glyphIcon: Theme.mode === "light" ? Utils.Icons.darkMode : Utils.Icons.lightMode,
            iconName: "",
            title: Theme.mode === "light" ? "Activar Modo Oscuro" : "Activar Modo Claro",
            subtitle: ">theme  •  Alternar esquema de color de Matugen",
            basePriority: 24,
            entry: null,
            cmd: []
        }
    ]

    readonly property var desktopApps: {
        const rawList = DesktopEntries.applications.values;
        const result = [];
        for (let i = 0; i < rawList.length; ++i) {
            const app = rawList[i];
            if (!app || app.noDisplay)
                continue;
            result.push({
                isAction: false,
                actionType: "desktop",
                glyphIcon: "",
                iconName: app.icon || "application-x-executable",
                title: app.name || "",
                subtitle: app.comment || app.genericName || app.id || "",
                basePriority: root.computeBasePriority(app),
                entry: app,
                cmd: []
            });
        }
        result.sort((a, b) => (b.basePriority - a.basePriority) || a.title.localeCompare(b.title));
        return result;
    }

    function scoreItem(item, q) {
        const title = String(item.title || "").toLowerCase();
        const sub = String(item.subtitle || "").toLowerCase();
        let matchScore = 0;
        if (title === q)
            matchScore = 100;
        else if (title.startsWith(q))
            matchScore = 85;
        else if (title.includes(" " + q))
            matchScore = 70;
        else if (title.includes(q))
            matchScore = 55;
        else if (sub.includes(q))
            matchScore = 35;

        if (matchScore === 0)
            return 0;

        return matchScore + ((item.basePriority ?? 0) * 0.35);
    }

    readonly property var appResults: {
        const q = root.subQuery.toLowerCase();

        if (root.mode === "actions") {
            if (!q)
                return root.actionEntries;
            return root.actionEntries.filter(a => root.scoreItem(a, q) > 0);
        }

        if (!q) {
            const combined = root.desktopApps.concat(root.actionEntries);
            combined.sort((a, b) => ((b.basePriority ?? 0) - (a.basePriority ?? 0)) || a.title.localeCompare(b.title));
            return combined;
        }

        const scored = [];
        const candidates = root.desktopApps.concat(root.actionEntries);
        for (let i = 0; i < candidates.length; ++i) {
            const item = candidates[i];
            const s = root.scoreItem(item, q);
            if (s > 0)
                scored.push({ item: item, score: s });
        }
        scored.sort((a, b) => (b.score - a.score) || ((b.item.basePriority ?? 0) - (a.item.basePriority ?? 0)) || a.item.title.localeCompare(b.item.title));
        return scored.map(entry => entry.item);
    }

    readonly property var wallpaperResults: Theme.queryWallpapers(root.isWallpaperMode ? root.subQuery : "")

    function setQuery(text) {
        root.query = String(text ?? "");
    }

    function clear() {
        root.query = "";
    }

    function enterWallpaperMode() {
        root.query = ">wallpaper ";
    }

    function syncFromOverride(overrideName) {
        const ov = String(overrideName || "").toLowerCase();
        if (ov === "wallpapers" || ov === "wallpaper") {
            if (!root.isWallpaperMode)
                root.query = ">wallpaper ";
        } else {
            if (root.isWallpaperMode)
                root.query = "";
        }
    }

    function activateAppAt(index) {
        const list = root.appResults;
        if (list && index >= 0 && index < list.length) {
            const item = list[index];
            if (item) {
                if (item.isAction) {
                    if (item.actionType === "wallpaper") {
                        root.enterWallpaperMode();
                        return "wallpaper";
                    }
                    if (item.actionType === "toggleTheme") {
                        Theme.mode = Theme.mode === "light" ? "dark" : "light";
                        root.clear();
                        ShellState.close();
                        return "closed";
                    }
                }
                if (item.entry) {
                    item.entry.execute();
                    root.clear();
                    ShellState.close();
                    return "closed";
                }
                if (item.cmd && item.cmd.length > 0) {
                    Quickshell.execDetached(item.cmd);
                    root.clear();
                    ShellState.close();
                    return "closed";
                }
            }
        }
        const clean = root.normalizedInput.trim();
        if (clean.length > 0 && !clean.startsWith(">") && !clean.startsWith(":")) {
            Quickshell.execDetached(["sh", "-c", clean]);
            root.clear();
            ShellState.close();
            return "closed";
        }
        return "none";
    }

    function applyWallpaperAt(index) {
        const list = root.wallpaperResults;
        if (!list || list.length === 0)
            return;
        const idx = Math.max(0, Math.min(list.length - 1, index));
        const entry = list[idx];
        if (entry && entry.path) {
            Theme.apply(entry.path);
            root.clear();
            ShellState.close();
        }
    }

    function applyWallpaperPath(filePath) {
        if (!filePath)
            return;
        Theme.apply(filePath);
        root.clear();
        ShellState.close();
    }
}
