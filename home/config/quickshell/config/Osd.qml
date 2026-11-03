import Quickshell.Io

JsonObject {
    property bool enabled: true

    property JsonObject volume: JsonObject {
        property bool enabled: true
        property int width: 260
        property int height: 52
        property int timeoutMs: 1500
        property JsonObject position: JsonObject {
            property string bar: "bottom"
            property string section: "right"
        }
    }

    property JsonObject notifications: JsonObject {
        property bool enabled: true
        property int width: 360
        property int minHeight: 74
        property int timeoutMs: 4500
        property int maxPopups: 4
        property JsonObject position: JsonObject {
            property string bar: "bottom"
            property string section: "right"
        }
    }
}
