import Quickshell.Io

JsonObject {
    property string position: "top"
    property int height: 40
    property int width: 100
    property int cornerRadius: 15
    property bool attached: true
    property int margins: 14
    property int islandMarginTop: 5
    property int moduleSpacing: 18
    property int itemSpacing: 6
    property int radius: 6
    property real surfaceAlpha: 0.60
    property real borderAlpha: 0.15
    property string clockFormat: "HH:mm"
    property bool islands: true
    property list<string> leftModules: ["workspaces"]
    property list<string> centerModules: ["clock"]
    property list<string> rightModules: ["network", "audio"]
    property string leftPanel: "workspaces"
    property string centerPanel: "controlCenter"
    property string rightPanel: "status"
}
