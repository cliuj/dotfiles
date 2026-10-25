pragma Singleton
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Wi-Fi
    readonly property bool wifiOn: Networking.wifiEnabled
    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property string ssid: wifiDevice?.networks.values.find(n => n.connected)?.name ?? ""

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    // Bluetooth (adapter is null while bluetooth.service is stopped)
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool btAvailable: adapter !== null
    readonly property bool btOn: adapter?.enabled ?? false
    readonly property int btConnected: Bluetooth.devices.values.filter(d => d.connected).length

    function toggleBluetooth() {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }

    // Airplane mode: on when every rfkill device is soft-blocked
    property var rfkillSoft: ({})       // rfkill id -> soft-blocked
    readonly property bool airplane: {
        const ids = Object.keys(rfkillSoft);
        return ids.length > 0 && ids.every(id => rfkillSoft[id]);
    }

    function toggleAirplane() {
        Quickshell.execDetached(["rfkill", airplane ? "unblock" : "block", "all"]);
    }

    // Line format: "<time>: idx 2 type 1 op 0 soft 0 hard 0"
    // op 0 = device added, 1 = removed, 2 = changed
    function handleRfkill(line) {
        const m = line.match(/idx (\d+) type \d+ op (\d+) soft (\d+)/);
        if (!m) {
            // not an event line
            return;
        }
        const [, id, op, soft] = m;  // skip m[0], the full match
        const next = Object.assign({}, rfkillSoft);
        if (op === "1") {
            delete next[id];
        } else {
            next[id] = soft === "1";
        }
        rfkillSoft = next;
    }

    // Prints every device once at start, then one line per change.
    Process {
        running: true
        command: ["rfkill", "event"]
        stdout: SplitParser {
            onRead: line => root.handleRfkill(line)
        }
    }
}
