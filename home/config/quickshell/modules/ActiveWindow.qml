pragma ComponentBehavior: Bound

import QtQuick
import "../components"
import "../services"
import qs

StatusPill {
    id: root

    visible: Config.windowTitle.enabled && Hypr.displayTitle.length > 0

    icon: Config.windowTitle.showIcon ? Hypr.windowIcon : ""
    text: Hypr.displayTitle

    iconColor: Theme.primary
    textColor: Theme.textOnSurface
    clickable: false
}
