pragma ComponentBehavior: Bound

import QtQuick
import qs
import "."
import "../../services"

PathView {
    id: root

    readonly property var wallpapers: Search.wallpaperResults

    model: root.wallpapers

    readonly property int visibleSlots: {
        const c = count;
        if (c <= 0)
            return 0;
        if (c === 1 || c === 2)
            return 1;
        return 3;
    }

    pathItemCount: visibleSlots
    cacheItemCount: 4
    snapMode: PathView.SnapToItem
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange
    highlightMoveDuration: Config.anim.normal

    function syncCurrentIndex() {
        const list = root.wallpapers;
        if (!list || list.length === 0)
            return;
        if (Search.subQuery.length > 0) {
            currentIndex = 0;
            return;
        }
        const idx = list.findIndex(w => w.path === Theme.currentWallpaper);
        currentIndex = idx >= 0 ? idx : 0;
    }

    function applyCurrent() {
        Search.applyWallpaperAt(currentIndex);
    }

    onModelChanged: syncCurrentIndex()
    Component.onCompleted: syncCurrentIndex()

    path: Path {
        startX: 0
        startY: root.height / 2

        PathAttribute {
            name: "itemZ"
            value: 0
        }
        PathLine {
            x: root.width / 2
            relativeY: 0
        }
        PathAttribute {
            name: "itemZ"
            value: 10
        }
        PathLine {
            x: root.width
            relativeY: 0
        }
        PathAttribute {
            name: "itemZ"
            value: 0
        }
    }

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0 || event.angleDelta.x > 0)
                root.incrementCurrentIndex();
            else if (event.angleDelta.y > 0 || event.angleDelta.x < 0)
                root.decrementCurrentIndex();
        }
    }

    delegate: WallpaperItem {
        onSelectRequested: itemIndex => {
            root.currentIndex = itemIndex;
        }
        onApplyRequested: filePath => {
            Search.applyWallpaperPath(filePath);
        }
    }
}
