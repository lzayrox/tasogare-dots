import QtQuick
import QtQuick.Effects
import qs

Column {
    id: root

    property real s: 1.0
    property string fontFamily: "SF Pro Display"

    spacing: 8 * s

    property string timeString: Qt.formatDateTime(new Date(), "HH:mm")
    property string dateString: Qt.formatDateTime(new Date(), "dddd · MMMM d").toUpperCase()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            root.timeString = Qt.formatDateTime(now, "HH:mm");
            root.dateString = Qt.formatDateTime(now, "dddd · MMMM d").toUpperCase();
        }
    }

    Text {
        id: clockText
        text: root.timeString
        color: Theme.textOnSurface
        font.family: root.fontFamily
        font.pixelSize: Math.round(96 * root.s)
        font.weight: Font.Light
        font.letterSpacing: -1 * root.s
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#40000000"
            shadowBlur: 0.6
            shadowVerticalOffset: 2
        }
    }

    Text {
        id: dateText
        text: root.dateString
        color: Theme.secondary
        font.family: root.fontFamily
        font.pixelSize: Math.round(12 * root.s)
        font.letterSpacing: 3 * root.s
        font.weight: Font.Light
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#30000000"
            shadowBlur: 0.4
            shadowVerticalOffset: 1
        }
    }
}
