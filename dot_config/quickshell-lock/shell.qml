pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    LockContext {
        id: lockContext

        onUnlocked: {
            // Unlock before quitting, or niri shows a fallback lock you cannot use
            lock.locked = false;
            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock

        // Lock as soon as the process starts; hypridle starts it through systemd
        locked: true

        WlSessionLockSurface {
            id: surface
            color: "#0a0f20"

            LockSurface {
                anchors.fill: parent
                context: lockContext
                screenName: surface.screen ? surface.screen.name : ""
            }
        }
    }
}
