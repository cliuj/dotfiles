import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick
import qs.services
import qs.components

PanelWindow {
    id: bar
    required property ShellScreen modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 38 + 8
    color: "transparent"
    WlrLayershell.namespace: "quickshell-bar"

    // Caffeine: keeps hypridle from locking while the toggle is on
    IdleInhibitor {
        enabled: Caffeine.on
        window: bar
    }

    // Blur only behind the three islands, not the whole transparent strip.
    BackgroundEffect.blurRegion: Region {
        Region {
            item: leftIsland
            radius: Theme.radiusIsland
        }
        Region {
            item: clockIsland
            radius: Theme.radiusIsland
        }
        Region {
            item: rightIsland
            radius: Theme.radiusIsland
        }
    }

    Island {
        id: leftIsland
        anchors {
            left: parent.left
            leftMargin: Theme.gap
            bottom: parent.bottom
        }
        Workspaces {
            output: bar.modelData.name
        }

        Rectangle {
            implicitWidth: 1
            implicitHeight: 16
            color: Theme.line
        }

        ColumnStrip {
            output: bar.modelData.name
            screenWidth: bar.modelData.width
        }

        Rectangle {
            implicitWidth: 1
            implicitHeight: 16
            color: Theme.line
        }

        Text {
            text: Niri.focusedWindow?.title ?? ""
            color: Theme.muted
            elide: Text.ElideRight
            Layout.maximumWidth: 300
            font {
                family: Theme.font
                pixelSize: Theme.fontSize
            }
        }
    }

    Clock {
        id: clockIsland
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
    }

    StatusCluster {
        id: rightIsland
        clickable: true
        active: Panels.current === "qs" && Panels.screen === bar.modelData
        onClicked: Panels.toggle("qs", bar.modelData)
        anchors {
            right: parent.right
            rightMargin: Theme.gap
            bottom: parent.bottom
        }
    }
}
