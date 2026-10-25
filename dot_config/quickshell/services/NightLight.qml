pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool on: false
    property int temperature: 3400      // Kelvin, lower = warmer

    function toggle() {
        on = !on;
    }

    // On Wayland, gammastep keeps running to hold the colour change.
    // Stopping the process restores normal colours.
    Process {
        running: root.on
        command: ["gammastep", "-m", "wayland", "-O", String(root.temperature), "-P"]
        // Keep the tile honest if gammastep fails or is killed
        onExited: root.on = false
    }
}
