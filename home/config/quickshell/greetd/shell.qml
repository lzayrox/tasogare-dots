import QtQuick
import Quickshell
import qs
import "." as App

ShellRoot {
    FloatingWindow {
        id: win
        visible: true
        fullscreen: true
        color: Theme.background

        readonly property real s: height > 0 ? (height / 768.0) : 1.0

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.ArrowCursor
            z: -1
        }

        Wallpaper {
            blurred: loginCard.isTyping
        }

        Item {
            id: uiContainer
            anchors.fill: parent

            Component.onCompleted: {
                App.Animation.playEnter(uiContainer);
            }

            Connections {
                target: Auth

                function onReadyToLaunch() {
                    App.Animation.playExit(uiContainer, function () {
                        Auth.launchSession();
                    });
                }
            }

            ClockWidget {
                id: clockWidget
                s: win.s
                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: Math.round(70 * win.s)
                    topMargin: Math.round(60 * win.s)
                }
            }

            LoginCard {
                id: loginCard
                s: win.s
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: Math.round(70 * win.s)
                    bottomMargin: Math.round(190 * win.s)
                }
            }
        }
    }
}
