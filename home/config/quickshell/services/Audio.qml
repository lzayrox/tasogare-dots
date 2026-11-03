pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import "../utils" as Utils

Singleton {
    id: root

    property var sink: Pipewire.defaultAudioSink
    property var source: Pipewire.defaultAudioSource

    readonly property bool ready: sink && sink.ready
    readonly property bool sourceReady: source && source.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property bool micMuted: sourceReady && source.audio.muted
    readonly property int volume: ready ? Math.round(sink.audio.volume * 100) : 0

    readonly property string icon: {
        if (!ready)
            return Utils.Icons.volumeMute;
        if (muted)
            return Utils.Icons.volumeOff;

        if (volume === 0)
            return Utils.Icons.volumeMute;
        if (volume < 34)
            return Utils.Icons.volumeLow;
        if (volume < 67)
            return Utils.Icons.volumeMid;

        return Utils.Icons.volumeHigh;
    }

    function toggleMute() {
        if (ready) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    function toggleMicMute() {
        if (sourceReady) {
            source.audio.muted = !source.audio.muted;
        }
    }

    function setVolume(val) {
        if (!ready)
            return;
        sink.audio.volume = Math.max(0.0, Math.min(1.5, val / 100.0));
    }

    function adjustVolume(deltaPercent) {
        if (!ready)
            return;
        const next = sink.audio.volume + (deltaPercent / 100.0);
        sink.audio.volume = Math.max(0.0, Math.min(1.5, next));
    }

    PwObjectTracker {
        objects: [root.sink, root.source]
    }
}
