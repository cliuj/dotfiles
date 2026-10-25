import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.services

RowLayout {
    id: root
    required property string output // monitor name, e.g "HDMI-A-1"
    spacing: 2

    Repeater {
        model: ScriptModel {
            values: Niri.workspaces.filter(w => w.output === root.output).sort((a, b) => a.idx - b.idx).map(w => w.id)
        }

        Item {
            id: cell
            required property int modelData // workspace id
            readonly property var ws: Niri.workspaces.find(w => w.id === modelData) ?? null
            readonly property bool active: ws?.is_active ?? false
            readonly property bool occupied: Niri.windows.some(w => w.workspaces_id === modelData)

            implicitWidth: dot.width + 6
            implicitHeight: 26 // hit area taller than the dot

            Rectangle {
                id: dot
                anchors.centerIn: parent
                width: cell.active ? 24 : 8
                height: 8
                radius: 4
                color: cell.active ? Theme.accent : cell.occupied ? Theme.muted : "transparent"
                border.width: cell.active || cell.occupied ? 0 : 1.5
                border.color: Theme.muted

                Behavior on width {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (cell.ws)
                    Niri.focusWorkspace(cell.ws.idx)
            }
        }
    }
}
