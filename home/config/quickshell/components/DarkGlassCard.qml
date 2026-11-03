pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../services"

GlassPanel {
    id: root

    property bool hovered: false

    surfaceColor: Theme.surfaceVariant
    surfaceAlpha: root.hovered ? 0.55 : 0.40
    customBorderColor: Theme.outline
    borderAlpha: root.hovered ? 0.24 : 0.14
    radius: 12
}
