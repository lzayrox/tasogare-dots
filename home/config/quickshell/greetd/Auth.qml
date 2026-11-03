pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd

Singleton {
    id: root

    property string statusKey: ""
    property string customMessage: ""
    property bool isError: false
    property bool authenticating: false

    readonly property string statusMessage: {
        if (customMessage.length > 0)
            return customMessage;
        if (statusKey.length > 0)
            return Strings.t(statusKey);
        return "";
    }

    signal readyToLaunch

    Process {
        id: powerProc
    }

    function login(username, password) {
        if (!username || username.length === 0)
            return;

        _passwordCache = password;
        authenticating = true;
        isError = false;
        customMessage = "";
        statusKey = "verifying";

        Greetd.createSession(username);
    }

    function launchSession() {
        Greetd.launch(["uwsm", "start", "hyprland-uwsm.desktop"]);
    }

    function reboot() {
        powerProc.exec(["systemctl", "reboot"]);
    }

    function powerOff() {
        powerProc.exec(["systemctl", "poweroff"]);
    }

    function suspend() {
        powerProc.exec(["systemctl", "suspend"]);
    }

    property string _passwordCache: ""

    Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            root.isError = error;

            if (error) {
                root.statusKey = "authFailed";
                root.customMessage = "";
            } else if (message && message.length > 0) {
                root.statusKey = "";
                root.customMessage = message;
            }

            if (responseRequired) {
                if (root._passwordCache.length > 0) {
                    Greetd.respond(root._passwordCache);
                }
            }
        }

        function onError(err) {
            root.statusKey = "authFailed";
            root.customMessage = err ? (Strings.t("authFailed") + " (" + err + ")") : "";
            root.isError = true;
            root.authenticating = false;
        }

        function onStateChanged() {
            if (Greetd.state === GreetdState.ReadyToLaunch) {
                root.statusKey = "authSuccess";
                root.customMessage = "";
                root.authenticating = false;
                root.readyToLaunch();
            }
        }
    }
}
