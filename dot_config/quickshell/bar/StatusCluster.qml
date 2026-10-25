import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Island {
    id: root

    Icon {
        readonly property bool off: !Networking.wifiEnabled
        name: off ? "wifi-off" : "wifi"
        opacity: off ? 0.35 : 1
    }

    Icon {
        readonly property bool off: !(Bluetooth.defaultAdapter?.enabled ?? false)
        name: off ? "bluetooth-off" : "bluetooth"
        opacity: off ? 0.35 : 1
    }

    Icon {
        name: Audio.icon
    }

    RowLayout {
        visible: Battery.ready
        spacing: 4

        Icon {
            name: Battery.icon
            color: Battery.low ? Theme.warn : Theme.text
        }

        Text {
            text: Battery.percent + "%"
            color: Theme.text
            font {
                family: Theme.fontMono
                pixelSize: Theme.fontSizeSmall
                weight: Font.Medium
            }
        }
    }
}
