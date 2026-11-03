pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs

Item {
    id: root
    anchors.fill: parent

    // Propiedad reactiva: se activa cuando el usuario empieza a escribir
    property bool blurred: false

    Image {
        id: bgImage
        anchors.fill: parent
        source: "file:///var/cache/greeter/wallpaper"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        visible: false
    }

    MultiEffect {
        id: blurImage
        anchors.fill: bgImage
        source: bgImage
        blurEnabled: true
        blurMax: 32
        blur: root.blurred ? 0.65 : 0.0

        Behavior on blur {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutCubic
            }
        }
    }

    // Velo oscuro que también se intensifica suavemente al escribir
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.blurred ? 0.35 : 0.15

        Behavior on opacity {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutCubic
            }
        }
    }

    // Fallback si la imagen aún no está disponible
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        visible: bgImage.status !== Image.Ready
    }
}
