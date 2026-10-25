import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.services

RowLayout {
    id: root
    required property string output
    required property int screenWidth
    spacing: 3

    readonly property var workspace: Niri.workspaces.find(w => w.output === output && w.is_active) ?? null

    // One entry per column: { width, focused }, in left-to-right order
    readonly property var columns: {
        const cols = [];
        for (const w of Niri.windows) {
            const pos = w.layout?.pos_in_scrolling_layout;
            if (w.workspace_id !== workspace?.id || w.is_floating || !pos)
                continue;
            const i = pos[0] - 1;
            if (!cols[i])
                cols[i] = {
                    width: 0,
                    focused: false
                };
            cols[i].width = Math.max(cols[i].width, w.layout.tile_size[0]);
            if (w.id === workspace.active_window_id)
                cols[i].focused = true;
        }
        return cols.filter(c => c);
    }

    visible: columns.length > 0

    Repeater {
        // Column indices only, so delegates survive updates and animate
        model: ScriptModel {
            values: root.columns.map((c, i) => i)
        }

        Rectangle {
            id: col
            required property int modelData
            readonly property var info: root.columns[modelData] ?? {
                width: 0,
                focused: false
            }

            // A full-screen column is about 24px wide in the bar
            implicitWidth: Math.max(6, Math.round(info.width / root.screenWidth * 24))
            implicitHeight: 18
            radius: 3
            color: info.focused ? Theme.accent : Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, 0.28)

            Behavior on implicitWidth {
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

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Niri.focusColumn(col.modelData + 1)
            }
        }
    }
}
