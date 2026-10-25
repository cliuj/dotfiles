pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    // Quickshell.screens lists enabled outputs only

    readonly property bool available: Quickshell.screens.some(s => s.name.startsWith("eDP"))
    property real value: 0        // 0 .. 1

    function refresh() {
        reader.running = true;
    }

    function set(v) {
        value = Math.max(0.01, Math.min(1, v));
        if (!throttle.running) {
            throttle.start();
        }
    }

    // Output looks like: amdgpu_bl1,backlight,88000,22%,400000
    Process {
        id: reader
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const f = this.text.trim().split(",");
                root.value = Number(f[2]) / Number(f[4]);
            }
        }
    }

    // Send at most one brightnessctl call per 50 ms while dragging
    Timer {
        id: throttle
        interval: 50
        onTriggered: Quickshell.execDetached(["brightnessctl", "-q", "set", Math.round(root.value * 100) + "%"])
    }

    // Read again each time quick settings opens
    Connections {
        target: Panels
        function onCurrentChanged() {
            if (Panels.current === "qs") {
                root.refresh();
            }
        }
    }

    Component.onCompleted: refresh()
}
