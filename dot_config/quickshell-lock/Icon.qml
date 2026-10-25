import Quickshell
import Quickshell.Io
import QtQuick

// Copy of the main shell's Icon, reading this config's own assets/lucide
Item {
    id: root
    required property string name // Lucide file name without .svg, e.g. "moon"
    property color color: "#e7ecff"
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
