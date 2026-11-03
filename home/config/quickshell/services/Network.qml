pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick
import "../utils" as Utils

Singleton {
    id: root

    // qmllint disable missing-property
    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var activeNetwork: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null
    // qmllint enable missing-property

    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool isConnected: activeNetwork !== null && activeNetwork !== undefined
    readonly property string ssid: (activeNetwork && activeNetwork.name) ? activeNetwork.name : "Disconnected"
    readonly property real signalStrength: activeNetwork ? activeNetwork.signalStrength : 0

    readonly property string icon: {
        if (!wifiEnabled)
            return Utils.Icons.wifiOff;
        if (!isConnected)
            return Utils.Icons.wifiDisconnected;

        return Utils.Icons.wifiStrength(signalStrength);
    }

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    function openNetworkSettings() {
        Quickshell.execDetached(["kitty", "--class", "float_term", "-e", "nmtui"]);
    }
}
