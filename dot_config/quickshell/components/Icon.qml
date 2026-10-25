import Quickshell
import Quickshell.Io
import QtQuick

import qs.services

Item {
    id: root
    required property string name // Lucide file name without .svg, e.g. "wifi-off"
    property color color: Theme.text
    property int size: 16

    implicitWidth: size
    implicitHeight: size

    FileView {
        id: file
        path: Quickshell.shellPath("assets/lucide/" + root.name + ".svg")
    }

    Image {
        anchors.fill: parent
        sourceSize: Qt.size(root.size, root.size)
        // Lucide draws with stroke="currentColor", so swap in our color
        source: file.loaded ? "data:image/svg+xml;utf8," + encodeURIComponent(file.text().replace(/currentColor/g, root.color)) : ""
    }
}
