pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    // UPower's combined battery device
    readonly property var device: UPower.displayDevice
    readonly property bool ready: device.ready
    readonly property real charge: device.percentage        // 0..1
    readonly property int percent: Math.round(charge * 100)
    readonly property bool pluggedIn: !UPower.onBattery
    readonly property bool charging: device.state === UPowerDeviceState.Charging
    readonly property bool full: device.state === UPowerDeviceState.FullyCharged
    readonly property bool low: !pluggedIn && charge < 0.15

    readonly property string icon: charging ? "battery-charging" : charge < 0.15 ? "battery" : charge < 0.4 ? "battery-low" : charge < 0.75 ? "battery-medium" : "battery-full"

    // "Full in 25m", "Empty in 2h 10m", "Full", or "" while UPower has no estimate
    readonly property string timeText: {
        if (full)
            return "Full";
        if (charging)
            return device.timeToFull > 0 ? "Full in " + formatDuration(device.timeToFull) : "";
        if (pluggedIn)
            return "Not charging";
        return device.timeToEmpty > 0 ? "Empty in " + formatDuration(device.timeToEmpty) : "";
    }

    // 1500 -> "25m", 7800 -> "2h 10m", 43200 -> "12h"
    function formatDuration(seconds) {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        if (hours >= 10)
            return hours + "h";
        if (hours > 0)
            return hours + "h " + minutes + "m";
        return minutes + "m";
    }

    // Charge limit: UPower supports it over D-Bus, but Quickshell has no property for it
    readonly property var laptopBattery: UPower.devices.values.find(d => d.isLaptopBattery) ?? null
    readonly property string dbusPath: laptopBattery ? "/org/freedesktop/UPower/devices/battery_" + laptopBattery.nativePath : ""
    property bool limitSupported: false
    property bool limitEnabled: false
    property int limitEnd: 80

    function refreshLimit() {
        if (dbusPath) {
            limitReader.running = true;
        }
    }

    function setLimit(enable) {
        limitEnabled = enable;       // show the change at once
        limitWriter.enable = enable;
        limitWriter.running = true;
    }

    // Output: one "<type> <value>" line per property, e.g. "b true", "u 80"
    function handleLimit(text) {
        const values = text.trim().split("\n").map(line => line.split(" ")[1]);
        const [supported, enabled, end] = values;
        limitSupported = supported === "true";
        limitEnabled = enabled === "true";
        limitEnd = Number(end);
    }

    Process {
        id: limitReader
        command: ["busctl", "--system", "get-property", "org.freedesktop.UPower", root.dbusPath, "org.freedesktop.UPower.Device", "ChargeThresholdSupported", "ChargeThresholdEnabled", "ChargeEndThreshold"]
        stdout: StdioCollector {
            onStreamFinished: root.handleLimit(this.text)
        }
    }

    Process {
        id: limitWriter
        property bool enable
        command: ["busctl", "--system", "call", "org.freedesktop.UPower", root.dbusPath, "org.freedesktop.UPower.Device", "EnableChargeThreshold", "b", String(enable)]
        // Read back the real state, also when the call fails.
        onExited: root.refreshLimit()
    }

    // Read again each time quick settings opens
    Connections {
        target: Panels
        function onCurrentChanged() {
            if (Panels.current === "qs") {
                root.refreshLimit();
            }
        }
    }

    onDbusPathChanged: refreshLimit()
}
