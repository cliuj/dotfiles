pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // Which panel is open: "" (none), "qs", "sidebar" or "apps"
    property string current: ""
    // The monitor the panel opened on
    property var screen: null

    function toggle(name, scr) {
        if (current === name && screen === scr) {
            close();
        } else {
            current = name;
            screen = scr;
        }
    }

    function close() {
        current = "";
    }
}
