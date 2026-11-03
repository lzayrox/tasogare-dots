pragma ComponentBehavior: Bound

import QtQuick
import qs
import "."
import "../../services"

ListView {
    id: root

    model: Search.appResults
    onModelChanged: root.currentIndex = 0

    spacing: 4
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    preferredHighlightBegin: 0
    preferredHighlightEnd: height
    highlightRangeMode: ListView.ApplyRange
    highlightFollowsCurrentItem: false

    highlight: Rectangle {
        width: root.width
        height: root.currentItem ? root.currentItem.height : 46
        y: root.currentItem ? root.currentItem.y : 0
        radius: 10
        color: Qt.alpha(Theme.primaryContainer, 0.45)
        border.width: 1
        border.color: Qt.alpha(Theme.primary, 0.35)
        visible: root.count > 0

        Behavior on y {
            NumberAnimation {
                duration: Config.anim.fast
                easing.type: Easing.OutCubic
            }
        }
    }

    function executeCurrent() {
        const idx = Math.max(0, root.currentIndex);
        Search.activateAppAt(idx);
    }

    delegate: AppItem {
        onClickedItem: itemIndex => {
            root.currentIndex = itemIndex;
        }
        onActivatedItem: itemIndex => {
            root.currentIndex = itemIndex;
            Search.activateAppAt(itemIndex);
        }
    }
}
