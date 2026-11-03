pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../services"

Item {
    id: root

    property string text: ""
    property int iconSize: 16
    property color iconColor: Theme.primary
    property bool animateOnChange: true

    width: root.implicitWidth
    height: root.implicitHeight
    implicitWidth: Math.max(currentLabel.implicitWidth, oldLabel.implicitWidth, root.iconSize)
    implicitHeight: Math.max(currentLabel.implicitHeight, oldLabel.implicitHeight, root.iconSize)

    property string previousGlyph: ""
    property string currentGlyph: root.text

    onTextChanged: {
        if (!root.animateOnChange) {
            currentGlyph = root.text;
            previousGlyph = "";
            return;
        }

        if (root.text === currentGlyph)
            return;

        if (currentGlyph === "") {
            currentGlyph = root.text;
            return;
        }

        previousGlyph = currentGlyph;
        currentGlyph = root.text;
        morphAnim.restart();
    }

    Text {
        id: oldLabel
        anchors.centerIn: parent
        text: root.previousGlyph
        color: root.iconColor
        visible: opacity > 0
        opacity: 0.0
        font {
            family: Config.font.nerdFamily
            pixelSize: root.iconSize
        }
    }

    Text {
        id: currentLabel
        anchors.centerIn: parent
        text: root.currentGlyph
        color: root.iconColor
        opacity: 1.0
        font {
            family: Config.font.nerdFamily
            pixelSize: root.iconSize
        }
    }

    ParallelAnimation {
        id: morphAnim

        NumberAnimation {
            target: oldLabel
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 150
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: currentLabel
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}
