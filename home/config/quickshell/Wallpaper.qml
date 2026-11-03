pragma ComponentBehavior: Bound
import Quickshell
import qs
import Quickshell.Wayland
import QtQuick

Variants {
    id: wallpaperVariants

    property string activeWallpaper: ""

    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            Item {
                anchors.fill: parent

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                }

                Image {
                    id: imgCurrent
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    Component.onCompleted: {
                        if (wallpaperVariants.activeWallpaper && wallpaperVariants.activeWallpaper.length > 0)
                            source = wallpaperVariants.activeWallpaper;
                    }
                }

                Image {
                    id: imgNext
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.0
                    scale: 1.05
                    asynchronous: true
                    cache: true
                }

                ParallelAnimation {
                    id: anim
                    NumberAnimation {
                        target: imgNext
                        property: "opacity"
                        from: 0.0
                        to: 1.0
                        duration: Config.wallpaper.transitionDuration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: imgNext
                        property: "scale"
                        from: 1.05
                        to: 1.0
                        duration: Config.wallpaper.transitionDuration
                        easing.type: Easing.OutCubic
                    }
                    onFinished: {
                        imgCurrent.source = imgNext.source;
                        imgNext.opacity = 0.0;
                        imgNext.scale = 1.05;
                    }
                }

                Connections {
                    target: wallpaperVariants
                    function onActiveWallpaperChanged() {
                        const target = wallpaperVariants.activeWallpaper;
                        if (!target || target.length === 0)
                            return;
                        if (imgCurrent.source.toString() === "") {
                            imgCurrent.source = target;
                            return;
                        }
                        if (target === imgCurrent.source.toString())
                            return;
                        imgNext.source = target;
                        anim.restart();
                    }
                }
            }
        }
    }
}
