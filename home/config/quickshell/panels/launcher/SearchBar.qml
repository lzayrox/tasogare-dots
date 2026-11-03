pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import "../../components"
import "../../services"
import "../../utils" as Utils

DarkGlassCard {
    id: root

    signal previousRequested()
    signal nextRequested()
    signal acceptedInput()

    Timer {
        id: focusTimer
        interval: 20
        repeat: false
        onTriggered: searchInput.forceActiveFocus()
    }

    function focusInput() {
        searchInput.forceActiveFocus();
        focusTimer.restart();
    }

    Component.onCompleted: {
        searchInput.text = Search.query;
        searchInput.cursorPosition = searchInput.text.length;
        root.focusInput();
    }

    onVisibleChanged: {
        if (visible)
            root.focusInput();
    }

    Connections {
        target: Search

        function onQueryChanged() {
            if (searchInput.text !== Search.query) {
                searchInput.text = Search.query;
                searchInput.cursorPosition = searchInput.text.length;
            }
            root.focusInput();
        }
    }

    implicitHeight: 44
    radius: 12
    surfaceColor: Theme.surfaceVariant
    surfaceAlpha: 0.55

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 10
        spacing: 10

        AnimatedIcon {
            text: Search.isWallpaperMode ? Utils.Icons.controlCenter : Utils.Icons.appBrowser
            iconColor: Theme.primary
            iconSize: 18
        }

        TextInput {
            id: searchInput
            Layout.fillWidth: true
            color: Theme.textOnSurface
            selectionColor: Theme.primary
            selectedTextColor: Theme.textOnPrimary
            font {
                family: Config.font.family
                pixelSize: 14
                weight: 500
            }
            focus: true
            activeFocusOnTab: true
            onTextEdited: Search.setQuery(text)
            Keys.onEscapePressed: event => {
                event.accepted = true;
                ShellState.close();
            }
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    ShellState.close();
                }
            }
            Keys.onUpPressed: event => {
                root.previousRequested();
                event.accepted = true;
            }
            Keys.onDownPressed: event => {
                root.nextRequested();
                event.accepted = true;
            }
            Keys.onTabPressed: event => {
                root.nextRequested();
                event.accepted = true;
            }
            Keys.onBacktabPressed: event => {
                root.previousRequested();
                event.accepted = true;
            }
            onAccepted: root.acceptedInput()

            Text {
                anchors.fill: parent
                visible: parent.text.length === 0
                text: "Buscar aplicaciones o escribe \">wallpaper \"..."
                color: Theme.outline
                font: parent.font
                verticalAlignment: Text.AlignVCenter
            }
        }

        RowLayout {
            visible: Search.isWallpaperMode
            spacing: 6

            DarkGlassCard {
                implicitWidth: 28
                implicitHeight: 28
                radius: 8
                surfaceColor: Theme.surfaceContainer
                surfaceAlpha: 0.65

                AnimatedIcon {
                    anchors.centerIn: parent
                    text: Theme.mode === "light" ? Utils.Icons.lightMode : Utils.Icons.darkMode
                    iconColor: Theme.primary
                    iconSize: 14
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Theme.mode = Theme.mode === "light" ? "dark" : "light"
                }
            }

            Repeater {
                model: 4

                DarkGlassCard {
                    id: seedChip
                    required property int index
                    readonly property bool isSelected: Theme.sourceColorIndex === index

                    implicitWidth: 26
                    implicitHeight: 28
                    radius: 8
                    surfaceColor: isSelected ? Theme.primaryContainer : Theme.surfaceContainer
                    surfaceAlpha: isSelected ? 0.85 : 0.50
                    customBorderColor: isSelected ? Theme.primary : Theme.outline
                    borderAlpha: isSelected ? 0.45 : 0.15

                    Text {
                        anchors.centerIn: parent
                        text: String(seedChip.index + 1)
                        color: seedChip.isSelected ? Theme.textOnPrimaryContainer : Theme.textOnSurface
                        font {
                            family: Config.font.family
                            pixelSize: 11
                            weight: seedChip.isSelected ? 700 : 500
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Theme.sourceColorIndex = seedChip.index
                    }
                }
            }
        }
    }
}
