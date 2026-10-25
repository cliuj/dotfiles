pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    // Converts the spec's rgba(255-scale, alpha) values to QML colors.
    function rgba(r, g, b, a) {
        return Qt.rgba(r / 255, g / 255, b / 255, a);
    }

    // Fonts
    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property string fontMono: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
    readonly property int fontSizeSmall: 12

    // Colors
    readonly property color glass: rgba(10, 15, 32, 0.64)
    readonly property color card: rgba(160, 180, 255, 0.07)
    readonly property color line: rgba(160, 180, 255, 0.16)
    readonly property color text: "#e7ecff"
    readonly property color muted: "#a3aed0"
    readonly property color accent: "#8fb4ff"
    readonly property color accentText: "#0b1430"
    readonly property color warm: "#f5b86a"
    readonly property color accentSoft: Qt.rgba(accent.r, accent.g, accent.b, 0.16)
    readonly property color warmSoft: Qt.rgba(warm.r, warm.g, warm.b, 0.16)

    // Shape
    readonly property int radiusIsland: 12
    readonly property int radiusPanel: 18
    readonly property int radiusCard: 14
    readonly property int gap: 10

    // Motion: cubic-bezier (0.2, 0.8, 0.2, 1) from the spec
    readonly property var curve: [0.2, 0.8, 0.2, 1, 1, 1]
}
