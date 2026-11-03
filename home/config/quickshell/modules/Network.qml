pragma ComponentBehavior: Bound

import QtQuick
import "../components"
import "../services"
import qs

StatusPill {
    id: root

    icon: Network.icon
    text: {
        if (!Network.wifiEnabled)
            return "Off";
        return Network.ssid;
    }

    iconColor: !Network.wifiEnabled 
        ? Theme.outline 
        : (!Network.isConnected ? Theme.tertiary : Theme.primary)

    textColor: !Network.wifiEnabled || !Network.isConnected 
        ? Theme.outline 
        : Theme.textOnSurface

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) {
            Network.toggleWifi();
        } else if (mouse.button === Qt.MiddleButton) {
            Network.openNetworkSettings();
        } else {
            ShellState.toggle("right");
        }
    }
}
