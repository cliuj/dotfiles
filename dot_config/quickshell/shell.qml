import Quickshell
import QtQuick
import qs.bar
import qs.components
import qs.quicksettings

ShellRoot {
    Variants {
        model: Quickshell.screens
        Scope {
            id: perScreen
            required property ShellScreen modelData

            Bar {
                modelData: perScreen.modelData
            }
            ClickCatcher {
                modelData: perScreen.modelData
            }
            QuickSettings {
                modelData: perScreen.modelData
            }
        }
    }
}
