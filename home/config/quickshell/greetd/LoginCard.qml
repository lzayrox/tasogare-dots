import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs
import "." as App

Column {
    id: cardRoot

    property real s: 1.0
    property string fontFamily: "SF Pro Display"
    property string username: "lzirox"
    property string hostname: Quickshell.env("HOSTNAME") || ""
    property bool capsLockOn: false
    readonly property bool isTyping: pwd.text.length > 0 || Auth.authenticating

    spacing: 0
    width: Math.round(240 * s)

    Process {
        command: ["hostname"]
        running: cardRoot.hostname.length === 0
        stdout: StdioCollector {
            onTextChanged: cardRoot.hostname = text.trim()
        }
    }

    Timer {
        interval: 300
        running: true
        onTriggered: pwd.forceActiveFocus()
    }

    Connections {
        target: Auth

        function onIsErrorChanged() {
            if (Auth.isError) {
                App.Animation.playShake(cardRoot);
                pwd.text = "";
                pwd.forceActiveFocus();
            }
        }
    }

    Row {
        id: userRow
        anchors.right: parent.right
        spacing: Math.round(4 * cardRoot.s)

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#35000000"
            shadowBlur: 0.5
            shadowVerticalOffset: 1
        }

        Text {
            id: userDisp
            text: cardRoot.username.toLowerCase()
            color: userMa.containsMouse ? Theme.primary : Theme.textOnSurface
            font.family: cardRoot.fontFamily
            font.pixelSize: Math.round(22 * cardRoot.s)
            font.weight: Font.Light
            font.letterSpacing: 3 * cardRoot.s

            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }

            MouseArea {
                id: userMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: pwd.forceActiveFocus()
            }
        }

        Text {
            text: "@" + cardRoot.hostname.toLowerCase()
            color: Theme.textOnSurfaceVariant
            font.family: cardRoot.fontFamily
            font.pixelSize: Math.round(16 * cardRoot.s)
            font.weight: Font.Light
            font.letterSpacing: 2 * cardRoot.s
            anchors.baseline: userDisp.baseline
            visible: cardRoot.hostname.length > 0
        }
    }

    Item {
        width: 1
        height: Math.round(22 * cardRoot.s)
    }

    Item {
        anchors.right: parent.right
        width: parent.width
        height: Math.round(46 * cardRoot.s)

        Rectangle {
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            width: parent.width
            height: pwd.activeFocus ? Math.max(2, Math.round(2 * cardRoot.s)) : Math.max(1, Math.round(1 * cardRoot.s))
            color: Auth.isError ? Theme.error : (pwd.activeFocus ? Theme.primary : Qt.rgba(Theme.textOnSurface.r, Theme.textOnSurface.g, Theme.textOnSurface.b, 0.25))

            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        TextInput {
            id: pwd
            anchors.fill: parent
            anchors.bottomMargin: Math.round(4 * cardRoot.s)
            horizontalAlignment: TextInput.AlignRight
            verticalAlignment: TextInput.AlignVCenter
            echoMode: TextInput.Password
            passwordCharacter: "·"
            color: Theme.textOnSurface
            font.family: cardRoot.fontFamily
            font.pixelSize: Math.round(20 * cardRoot.s)
            font.letterSpacing: 10 * cardRoot.s
            focus: true
            clip: true
            cursorVisible: false
            cursorDelegate: Item {
                width: 0
                height: 0
            }

            onAccepted: {
                if (text.length > 0 && !Auth.authenticating) {
                    Auth.login(cardRoot.username, text);
                }
            }

            Keys.onEscapePressed: {
                text = "";
            }

            Keys.onPressed: function (event) {
                cardRoot.capsLockOn = (event.modifiers & Qt.ShiftModifier) ? false : (event.key >= Qt.Key_A && event.key <= Qt.Key_Z && event.text.length > 0 && event.text === event.text.toUpperCase());
            }

            Text {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                text: Auth.authenticating ? Strings.current.verifying : Strings.current.passwordPlaceholder
                color: Auth.authenticating ? Theme.primary : Theme.textOnSurface
                opacity: (pwd.text.length === 0 || Auth.authenticating) ? 0.55 : 0
                font.family: cardRoot.fontFamily
                font.pixelSize: Math.round(13 * cardRoot.s)
                font.letterSpacing: 2 * cardRoot.s
                font.weight: Font.Light

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#30000000"
                    shadowBlur: 0.4
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            Rectangle {
                id: cursor
                width: Math.max(2, Math.round(2 * cardRoot.s))
                height: Math.round(20 * cardRoot.s)
                color: Theme.primary
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                visible: pwd.activeFocus && pwd.text.length > 0 && !Auth.authenticating

                SequentialAnimation {
                    loops: Animation.Infinite
                    running: cursor.visible
                    NumberAnimation {
                        target: cursor
                        property: "opacity"
                        from: 1.0
                        to: 0.1
                        duration: 450
                    }
                    NumberAnimation {
                        target: cursor
                        property: "opacity"
                        from: 0.1
                        to: 1.0
                        duration: 450
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            onClicked: pwd.forceActiveFocus()
        }
    }

    Item {
        width: 1
        height: Math.round(20 * cardRoot.s)
    }

    Row {
        anchors.right: parent.right
        spacing: Math.round(20 * cardRoot.s)

        Repeater {
            model: [
                {
                    key: "session",
                    action: 0
                },
                {
                    key: "reboot",
                    action: 1
                },
                {
                    key: "poweroff",
                    action: 2
                },
                {
                    key: "suspend",
                    action: 3
                }
            ]

            delegate: Text {
                required property var modelData
                text: Strings.t(modelData.key)
                color: actionMa.containsMouse ? Theme.primary : Theme.textOnSurface
                font.family: cardRoot.fontFamily
                font.pixelSize: Math.round(11 * cardRoot.s)
                font.letterSpacing: 2 * cardRoot.s
                font.weight: Font.Light
                opacity: actionMa.containsMouse ? 1.0 : 0.7

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#35000000"
                    shadowBlur: 0.4
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                MouseArea {
                    id: actionMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.action === 1)
                            Auth.reboot();
                        else if (modelData.action === 2)
                            Auth.powerOff();
                        else if (modelData.action === 3)
                            Auth.suspend();
                    }
                }
            }
        }
    }

    Item {
        width: 1
        height: Math.round(12 * cardRoot.s)
    }

    Text {
        id: errorMsg
        anchors.right: parent.right
        text: {
            if (Auth.isError)
                return Strings.current.authFailed;
            if (cardRoot.capsLockOn)
                return Strings.current.capsLockWarning;
            return "";
        }
        color: Theme.error
        visible: text !== ""
        font.family: cardRoot.fontFamily
        font.pixelSize: Math.round(11 * cardRoot.s)
        font.letterSpacing: 1.5 * cardRoot.s
    }
}
