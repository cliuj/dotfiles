pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // Blocks lock and screen-off while true (see the IdleInhibitor in Bar.qml)
    property bool on: false

    function toggle() {
        on = !on;
    }
}
