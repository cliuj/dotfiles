pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Raw objects from niri's JSON (see `niri msg --json workspaces` / `windows`)
    property var workspaces: []
    property var windows: []

    readonly property var focusedWindow: windows.find(w => w.is_focused) ?? null

    function focusWorkspace(idx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)]);
    }

    function focusColumn(index) {
        Quickshell.execDetached(["niri", "msg", "focus-column", String(index)]);
    }

    function handle(event) {
        if (event.WorkspacesChanged) {
            workspaces = event.WorkspacesChanged.workspaces;
        } else if (event.WorkspaceActivated) {
            const ev = event.WorkspaceActivated;
            const output = workspaces.find(w => w.id === ev.id)?.output;
            workspaces = workspaces.map(w => Object.assign({}, w, {
                    is_active: w.output === output ? w.id === ev.id : w.is_active,
                    is_focused: ev.focused ? w.id === ev.id : w.is_focused
                }));
        } else if (event.WindowsChanged) {
            windows = event.WindowsChanged.windows;
        } else if (event.WindowOpenedOrChanged) {
            const win = event.WindowOpenedOrChanged.window;
            const others = windows.filter(w => w.id !== win.id).map(w => win.is_focused ? Object.assign({}, w, {
                    is_focused: false
                }) : w);
            windows = others.concat([win]);
        } else if (event.WindowClosed) {
            windows = windows.filter(w => w.id !== event.WindowClosed.id);
        } else if (event.WindowFocusChanged) {
            const id = event.WindowFocusChanged.id; // null when nothing is focused
            windows = windows.map(w => Object.assign({}, w, {
                    is_focused: w.id === id
                }));
        } else if (event.WindowLayoutsChanged) {
            // change is a list of [windowId, layout] pairs
            const changes = new Map(event.WindowLayoutsChanged.changes);
            windows = windows.map(w => changes.has(w.id) ? Object.assign({}, w, {
                    layout: changes.get(w.id)
                }) : w);
        } else if (event.WorkspaceActiveWindowChanged) {
            const ev = event.WorkspaceActiveWindowChanged;
            workspaces = workspaces.map(w => w.id === ev.workspace_id ? Object.assign({}, w, {
                    active_window_id: ev.active_window_id
                }) : w);
        }
    }

    Process {
        running: true
        command: ["niri", "msg", "--json", "event-stream"]
        stdout: SplitParser {
            onRead: line => root.handle(JSON.parse(line))
        }
    }
}
