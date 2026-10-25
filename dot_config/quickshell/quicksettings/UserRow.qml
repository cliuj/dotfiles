import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

RowLayout {
    id: root
    spacing: 10

    // Avatar: first letter of the user name
    Rectangle {
        implicitWidth: 40
        implicitHeight: 40
        radius: 12
        color: Theme.accent

        Text {
            anchors.centerIn: parent
            text: Session.user.charAt(0).toUpperCase()
            color: Theme.accentText
            font {
                family: Theme.font
                pixelSize: 16
                weight: Font.Bold
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        Text {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: Session.user + "@" + Session.host
            color: Theme.text
            font {
                family: Theme.font
                pixelSize: Theme.fontSize
                weight: Font.DemiBold
            }
        }

        Text {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: ["up " + Session.uptime, Session.desktop].filter(s => s !== "up ").join(" \u00b7 ")
            color: Theme.muted
            font {
                family: Theme.font
                pixelSize: Theme.fontSizeSmall
            }
        }
    }
}
