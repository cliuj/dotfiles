import QtQuick
import Quickshell

// Runs the lock surface in a normal window: qs -p ~/.config/quickshell-lock/test.qml
// It uses real PAM, so wrong passwords here count towards faillock too.
ShellRoot {
    LockContext {
        id: lockContext
        dryRun: true
        onUnlocked: Qt.quit()
    }

    FloatingWindow {
        implicitWidth: 1440
        implicitHeight: 900
        color: "#0a0f20"

        LockSurface {
            anchors.fill: parent
            context: lockContext
            screenName: lockContext.primaryName
        }
    }

    Connections {
        target: Quickshell

        function onLastWindowClosed() {
            Qt.quit();
        }
    }
}
