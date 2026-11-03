pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs
import "../components"
import "../services"

StatusPill {
    id: root

    property bool showAltFormat: false
    readonly property string activeFormat: showAltFormat
        ? Config.clock.altFormat
        : (Config.clock.format || Config.bar.clockFormat)

    text: Qt.formatDateTime(clock.date, root.activeFormat)
    textColor: Theme.textOnSurface
    clickable: Config.clock.interactive

    onClicked: mouse => {
        if (!Config.clock.interactive)
            return;

        if (mouse.button === Qt.RightButton)
            root.showAltFormat = !root.showAltFormat;
        else if (mouse.button === Qt.LeftButton)
            ShellState.toggle("center");
    }

    SystemClock {
        id: clock
        precision: root.activeFormat.includes("ss") ? SystemClock.Seconds : SystemClock.Minutes
    }
}
