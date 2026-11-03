pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property bool isOpen: ShellState.isOpen && ShellState.isControlCenterOpen

    function toggle() {
        ShellState.toggle("controlCenter");
    }

    function open() {
        ShellState.open("controlCenter");
    }

    function close() {
        ShellState.close();
    }

    Process {
        id: powerProc
    }

    function openFloatingTerminal() {
        Quickshell.execDetached(["kitty", "--class", "float_term"]);
        close();
    }

    function suspend() {
        powerProc.exec(["systemctl", "suspend"]);
        close();
    }

    function reboot() {
        powerProc.exec(["systemctl", "reboot"]);
        close();
    }

    function poweroff() {
        powerProc.exec(["systemctl", "poweroff"]);
        close();
    }
}
