import Quickshell
import Quickshell.Io

JsonObject {
    property JsonObject workspaces: JsonObject {
        property int count: 5
        property string style: "pills"
        property bool hideEmpty: false
        property bool scrollSwitch: true
    }

    property JsonObject clock: JsonObject {
        property string format: "ddd dd MMM  •  HH:mm"
        property string altFormat: "HH:mm"
        property bool interactive: true
    }

    property JsonObject windowTitle: JsonObject {
        property bool enabled: true
        property bool showIcon: false
        property int maxLength: 40
    }

    property JsonObject media: JsonObject {
        property bool enabled: true
        property int maxLength: 28
        property int volumeMorphTimeout: 1600
        property int scrollStep: 5
    }

    property JsonObject wallpaper: JsonObject {
        property string directory: Quickshell.env("HOME") + "/Pictures/Wallpaper"
        property int transitionDuration: 800
    }
}
