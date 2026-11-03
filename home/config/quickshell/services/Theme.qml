pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel

Singleton {
    id: root

    property color primary: "#bec2ff"
    property color textOnPrimary: "#262b60"
    property color primaryContainer: "#3d4279"
    property color textOnPrimaryContainer: "#e0e0ff"

    property color secondary: "#c5c4dd"
    property color textOnSecondary: "#2e2f42"

    property color tertiary: "#d6bee4"
    property color textOnTertiary: "#3b2948"
    property color tertiaryContainer: "#523f5f"
    property color textOnTertiaryContainer: "#f2daff"

    property color error: "#ffb4ab"
    property color textOnError: "#690005"
    property color errorContainer: "#93000a"
    property color textOnErrorContainer: "#ffdad6"

    property color surface: "#131318"
    property color textOnSurface: "#e4e1e9"
    property color surfaceVariant: "#46464f"
    property color textOnSurfaceVariant: "#c7c5d0"
    property color surfaceContainer: "#1c2024"

    property color background: "#131318"
    property color textOnBackground: "#e4e1e9"
    property color outline: "#91909a"

    function applyColors(raw) {
        if (!raw) return;
        try {
            const colors = JSON.parse(raw);
            if (colors.primary) root.primary = colors.primary;
            if (colors.on_primary) root.textOnPrimary = colors.on_primary;
            if (colors.primary_container) root.primaryContainer = colors.primary_container;
            if (colors.on_primary_container) root.textOnPrimaryContainer = colors.on_primary_container;

            if (colors.secondary) root.secondary = colors.secondary;
            if (colors.on_secondary) root.textOnSecondary = colors.on_secondary;

            if (colors.tertiary) root.tertiary = colors.tertiary;
            if (colors.on_tertiary) root.textOnTertiary = colors.on_tertiary;
            if (colors.tertiary_container) root.tertiaryContainer = colors.tertiary_container;
            if (colors.on_tertiary_container) root.textOnTertiaryContainer = colors.on_tertiary_container;

            if (colors.error) root.error = colors.error;
            if (colors.on_error) root.textOnError = colors.on_error;
            if (colors.error_container) root.errorContainer = colors.error_container;
            if (colors.on_error_container) root.textOnErrorContainer = colors.on_error_container;

            if (colors.surface) root.surface = colors.surface;
            if (colors.on_surface) root.textOnSurface = colors.on_surface;
            if (colors.surface_variant) {
                root.surfaceVariant = colors.surface_variant;
                root.surfaceContainer = colors.surface_variant;
            }
            if (colors.on_surface_variant) root.textOnSurfaceVariant = colors.on_surface_variant;

            if (colors.background) root.background = colors.background;
            if (colors.on_background) root.textOnBackground = colors.on_background;
            if (colors.outline) root.outline = colors.outline;
        } catch (e) {
            console.warn("[Theme] Error parseando colors.json:", e);
        }
    }

    FileView {
        id: colorsFile
        path: Quickshell.env("HOME") + "/.local/state/quickshell/colors.json"
        watchChanges: true

        onFileChanged: reload()
        onLoaded: root.applyColors(text())
    }

    property string currentWallpaper: ""

    FileView {
        id: wallpaperFile
        path: Quickshell.env("HOME") + "/.local/state/quickshell/wallpaper.json"
        watchChanges: true

        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data && data.path && data.path.length > 0)
                    root.currentWallpaper = data.path;
            } catch (e) {
                console.warn("[Theme] Error leyendo wallpaper.json:", e);
            }
        }

        onFileChanged: reload()
    }

    property string mode: "dark"
    property int sourceColorIndex: 0

    FileView {
        id: themeFile
        path: Quickshell.env("HOME") + "/.local/state/quickshell/theme.json"
        watchChanges: true

        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data) {
                    if (data.mode)
                        root.mode = data.mode;
                    if (data.sourceColorIndex !== undefined)
                        root.sourceColorIndex = data.sourceColorIndex;
                }
            } catch (e) {
                console.warn("[Theme] Error leyendo theme.json:", e);
            }
        }

        onFileChanged: reload()
    }

    Process {
        id: matugenProc
    }

    Process {
        id: syncProc
    }

    property alias wallpaperModel: folderModel
    property var wallpapers: []

    function syncWallpapers() {
        const list = [];
        for (let i = 0; i < folderModel.count; ++i) {
            const fileName = folderModel.get(i, "fileName");
            const filePath = folderModel.get(i, "filePath");
            if (!fileName || !filePath)
                continue;
            const baseName = fileName.replace(/\.[^/.]+$/, "");
            list.push({
                name: fileName,
                baseName: baseName,
                path: filePath
            });
        }
        root.wallpapers = list;
        if (root.currentWallpaper === "" && list.length > 0)
            root.currentWallpaper = list[0].path;
    }

    function queryWallpapers(search) {
        const q = String(search || "").trim().toLowerCase();
        if (!q)
            return root.wallpapers;
        return root.wallpapers.filter(w => w.name.toLowerCase().includes(q) || w.baseName.toLowerCase().includes(q));
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + Quickshell.env("HOME") + "/Pictures/Wallpaper"
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.PNG", "*.JPG", "*.JPEG", "*.WEBP"]
        showDirs: false
        showHidden: false
        sortField: FolderListModel.Name
        onCountChanged: root.syncWallpapers()
        onStatusChanged: {
            if (folderModel.status === FolderListModel.Ready)
                root.syncWallpapers();
        }
    }

    function saveTheme() {
        syncProc.exec(["sh", "-c", "mkdir -p ~/.local/state/quickshell; printf '{\"mode\":\"%s\",\"sourceColorIndex\":%s}\\n' \"$1\" \"$2\" > ~/.local/state/quickshell/theme.json", "sh", root.mode, String(root.sourceColorIndex)]);
    }

    function apply(imagePath) {
        const targetPath = (imagePath && imagePath.length > 0) ? imagePath : root.currentWallpaper;
        if (!targetPath)
            return;

        if (root.currentWallpaper !== targetPath)
            root.currentWallpaper = targetPath;

        const args = ["matugen", "image", targetPath, "--source-color-index", String(root.sourceColorIndex)];
        if (root.mode === "light") {
            args.push("-m");
            args.push("light");
        } else {
            args.push("-m");
            args.push("dark");
        }

        matugenProc.exec(args);

        syncProc.exec(["sh", "-c", "mkdir -p ~/.local/state/quickshell /var/cache/greeter 2>/dev/null; printf '{\"path\":\"%s\"}\\n' \"$1\" > ~/.local/state/quickshell/wallpaper.json; cp \"$1\" /var/cache/greeter/wallpaper 2>/dev/null || true", "sh", targetPath]);
    }

    onModeChanged: {
        saveTheme();
        apply(currentWallpaper);
    }
    onSourceColorIndexChanged: {
        saveTheme();
        apply(currentWallpaper);
    }
}
