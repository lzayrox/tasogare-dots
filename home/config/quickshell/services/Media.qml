pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import "../utils" as Utils
import qs

Singleton {
    id: root

    // qmllint disable missing-property
    readonly property var activePlayer: {
        const players = Mpris.players.values;
        if (!players || players.length === 0)
            return null;
        const playing = players.find(p => p.playbackState === MprisPlaybackState.Playing);
        return playing ? playing : players[0];
    }
    // qmllint enable missing-property

    readonly property bool isAvailable: activePlayer !== null
    readonly property bool isPlaying: isAvailable && activePlayer.playbackState === MprisPlaybackState.Playing

    readonly property string rawTitle: isAvailable && activePlayer.trackTitle ? activePlayer.trackTitle : ""
    readonly property string rawArtist: isAvailable && activePlayer.trackArtist ? activePlayer.trackArtist : ""

    readonly property string displayTrack: {
        if (!isAvailable || rawTitle.length === 0)
            return "";

        let label = rawTitle;
        if (rawArtist.length > 0)
            label = rawArtist + " - " + rawTitle;

        const maxLen = Config.media.maxLength;
        if (label.length > maxLen)
            return label.substring(0, Math.max(1, maxLen - 3)) + "...";
        return label;
    }

    readonly property string mediaIcon: isPlaying ? Utils.Icons.mediaPlay : Utils.Icons.mediaPause

    function togglePlay() {
        if (activePlayer && activePlayer.canTogglePlayback)
            activePlayer.togglePlaying();
    }

    function nextTrack() {
        if (activePlayer && activePlayer.canGoNext)
            activePlayer.next();
    }

    function previousTrack() {
        if (activePlayer && activePlayer.canGoPrevious)
            activePlayer.previous();
    }
}
