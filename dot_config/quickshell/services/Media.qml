pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    // Players the card shows, highest priority first
    readonly property var sources: [
        {
            name: "Pear Desktop",
            desktopId: "com.github.th-ch.youtube-music",
            // MPRIS from pear-desktop's own plugin
            matches: p => p.dbusName === "org.mpris.MediaPlayer2.YoutubeMusic"
        },
        {
            name: "MPD",
            desktopId: "",
            // MPRIS from 'mpd-mpris'
            matches: p => p.dbusName === "org.mpris.MediaPlayer2.mpd"
        }
    ]

    // Open players from the list, in priority order
    readonly property var players: sources.map(source => Mpris.players.values.find(source.matches)).filter(p => p)

    // A playing player first, otherwise the top-priority one
    readonly property var player: players.find(p => p.isPlaying) ?? players[0] ?? null
    readonly property string playerName: sources.find(s => player && s.matches(player))?.name ?? ""
    readonly property real progress: player && player.length > 0 ? player.position / player.length : 0

    readonly property bool canShuffle: (player?.canControl ?? false) && player.shuffleSupported
    readonly property bool canLoop: (player?.canControl ?? false) && player.loopSupported
    readonly property bool shuffling: player?.shuffle ?? false
    readonly property bool looping: (player?.loopState ?? MprisLoopState.None) !== MprisLoopState.None
    readonly property bool loopingTrack: player?.loopState === MprisLoopState.Track
    readonly property bool canSeek: (player?.canControl ?? false) && player.canSeek && player.positionSupported

    function togglePlaying() {
        if (player?.canTogglePlaying)
            player.togglePlaying();
    }

    function toggleShuffle() {
        if (canShuffle) {
            player.shuffle = !player.shuffle;
        }
    }

    // Repeat cycles: off -> whole queue -> one track -> off
    function cycleLoop() {
        if (!canLoop) {
            return;
        }
        if (player.loopState === MprisLoopState.None) {
            player.loopState = MprisLoopState.Playlist;
        } else if (player.loopState === MprisLoopState.Playlist) {
            player.loopState = MprisLoopState.Track;
        } else {
            player.loopState = MprisLoopState.None;
        }
    }

    function next() {
        if (player?.canGoNext)
            player.next();
    }

    function previous() {
        if (player?.canGoPrevious)
            player.previous();
    }

    // fraction: 0 = start of the track, 1 = end
    function seekTo(fraction) {
        if (canSeek) {
            player.position = fraction * player.length;
        }
    }

    // Opens the top-priority app, for the "Nothing playing" state
    function launch() {
        DesktopEntries.byId(sources[0].desktopId)?.execute();
    }

    // Mpris doesn't update position by itself; refresh it once a second while playing
    Timer {
        running: root.player?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }
}
