pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string user: Quickshell.env("USER") ?? ""
    readonly property string host: hostFile.loaded ? hostFile.text().trim() : ""
    readonly property string desktop: Quickshell.env("XDG_CURRENT_DESKTOP") ?? ""

    // Read the boot time once; the clock then keeps the uptime current
    property real bootTime: 0
    readonly property string uptime: bootTime > 0 ? formatUptime(clock.date - bootTime) : ""

    // 2580000 -> "43m", 11520000 -> "3h 12m", 174810000 -> "2d 0h"
    function formatUptime(ms) {
        const totalMinutes = Math.floor(ms / 60000);
        const days = Math.floor(totalMinutes / 1440);
        const hours = Math.floor(totalMinutes % 1440 / 60);
        const minutes = totalMinutes % 60;
        if (days > 0)
            return days + "d " + hours + "h";
        if (hours > 0)
            return hours + "h " + minutes + "m";
        return minutes + "m";
    }

    function lock() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    // hypridle locks the screen before sleep and hibernate (its before-sleep rule)
    function suspend() {
        Quickshell.execDetached(["systemctl", "suspend"]);
    }

    function hibernate() {
        Quickshell.execDetached(["systemctl", "hibernate"]);
    }

    function reboot() {
        Quickshell.execDetached(["systemctl", "reboot"]);
    }

    function powerOff() {
        Quickshell.execDetached(["systemctl", "poweroff"]);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    FileView {
        id: hostFile
        path: "/etc/hostname"
    }

    // Output: "<seconds since boot> <idle seconds>", e.g. "174810.89 1284134.71"
    Process {
        running: true
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [secondsUp] = this.text.split(" ");
                root.bootTime = Date.now() - Number(secondsUp) * 1000;
            }
        }
    }
}
