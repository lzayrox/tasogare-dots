pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import qs

Singleton {
    id: root

    property bool dnd: false
    property var list: []
    property var popups: []
    property double lastPopupAt: 0
    readonly property int count: root.list.length
    readonly property int popupCount: root.popups.length
    readonly property int defaultTimeoutMs: Config.osd.notifications.timeoutMs

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => root.handleIncoming(notif)
    }

    Timer {
        id: expiryTimer
        interval: 250
        repeat: true
        running: root.popups.length > 0
        onTriggered: {
            const now = Date.now();
            const remaining = root.popups.filter(p => p.notif && p.expiresAt > now);
            if (remaining.length !== root.popups.length)
                root.popups = remaining;
        }
    }

    function formatTime() {
        const d = new Date();
        const hh = String(d.getHours()).padStart(2, "0");
        const mm = String(d.getMinutes()).padStart(2, "0");
        return hh + ":" + mm;
    }

    function handleIncoming(notif) {
        if (!notif)
            return;

        notif.tracked = true;

        const entry = {
            id: notif.id,
            notif: notif,
            appName: notif.appName || "Sistema",
            appIcon: notif.appIcon || "",
            image: notif.image || "",
            summary: notif.summary || "Notificación",
            body: notif.body || "",
            urgency: notif.urgency,
            actions: notif.actions || [],
            time: root.formatTime(),
            expiresAt: Date.now() + (notif.expireTimeout > 0 ? Math.min(12000, notif.expireTimeout * 1000) : root.defaultTimeoutMs)
        };

        const filteredList = root.list.filter(item => item.id !== notif.id);
        root.list = [entry].concat(filteredList).slice(0, Config.panels.notifications.maxHistory);

        if (!root.dnd && !notif.lastGeneration) {
            const filteredPopups = root.popups.filter(item => item.id !== notif.id);
            root.popups = [entry].concat(filteredPopups).slice(0, Config.osd.notifications.maxPopups);
            root.lastPopupAt = Date.now();
        }
    }

    function dismissPopup(notifId) {
        root.popups = root.popups.filter(item => item.id !== notifId);
    }

    function dismiss(notifId) {
        const found = root.list.find(item => item.id === notifId);
        root.popups = root.popups.filter(item => item.id !== notifId);
        root.list = root.list.filter(item => item.id !== notifId);
        if (found && found.notif) {
            try {
                found.notif.dismiss();
            } catch (e) {
            }
        }
    }

    function clearAll() {
        const current = root.list.slice();
        root.popups = [];
        root.list = [];
        for (let i = 0; i < current.length; ++i) {
            if (current[i] && current[i].notif) {
                try {
                    current[i].notif.dismiss();
                } catch (e) {
                }
            }
        }
    }

    function toggleDnd() {
        root.dnd = !root.dnd;
        if (root.dnd)
            root.popups = [];
    }
}
