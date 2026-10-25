import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services

PanelWindow {
    id: root
    required property ShellScreen modelData
    screen: modelData

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Normal   // stays below the bar
    color: Qt.rgba(0, 0, 0, 0.18)         // light scrim from the spec
    visible: Panels.current !== "" && Panels.screen === root.modelData

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-catcher"

    MouseArea {
        anchors.fill: parent
        onClicked: Panels.close()
    }
}
