pragma ComponentBehavior: Bound

import QtQuick
import "../components"
import "../services"
import "../utils" as Utils
import qs

StatusPill {
    id: root

    icon: Utils.Icons.controlCenter
    iconColor: ControlCenter.isOpen ? Theme.primary : Theme.outline

    onClicked: ControlCenter.toggle()
}
