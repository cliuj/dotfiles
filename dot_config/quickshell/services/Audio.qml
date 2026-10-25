pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property string deviceName: sink ? (sink.nickname || sink.description) : ""
    readonly property string icon: muted || volume === 0 ? "volume-x" : volume < 0.34 ? "volume" : volume < 0.67 ? "volume-1" : "volume-2"

    function setVolume(v) {
        if (sink?.audio) {
            sink.audio.volume = Math.max(0, Math.min(1, v));
        }
    }

    function toggleMute() {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
