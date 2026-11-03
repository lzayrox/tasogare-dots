pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "./config" as Cfg

Singleton {
    id: root

    readonly property string configPath: Quickshell.shellPath("config.json")

    property alias font: adapter.font
    property alias anim: adapter.anim
    property alias bar: adapter.bar
    property alias bottomBar: adapter.bottomBar
    property alias modules: adapter.modules
    property alias panels: adapter.panels
    property alias osd: adapter.osd

    readonly property var workspaces: adapter.modules.workspaces
    readonly property var clock: adapter.modules.clock
    readonly property var windowTitle: adapter.modules.windowTitle
    readonly property var media: adapter.modules.media
    readonly property var wallpaper: adapter.modules.wallpaper

    function save() {
        configFile.writeAdapter();
    }

    FileView {
        id: configFile
        path: root.configPath
        watchChanges: true

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property Cfg.Font font: Cfg.Font {}
            property Cfg.Anim anim: Cfg.Anim {}
            property Cfg.Bar bar: Cfg.Bar {}
            property Cfg.BottomBar bottomBar: Cfg.BottomBar {}
            property Cfg.Modules modules: Cfg.Modules {}
            property Cfg.Panels panels: Cfg.Panels {}
            property Cfg.Osd osd: Cfg.Osd {}
        }
    }
}
