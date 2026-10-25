import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
    id: root
    required property string icon
    required property string label
    property string detail: ""
    property bool on: false
    signal clicked

    // Equal-width columns in the grid
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    implicitHeight: Math.max(58, row.implicitHeight + 20)

    radius: Theme.radiusCard
    color: on ? Theme.accent : Theme.card
    border.width: on ? 0 : 1
    border.color: Theme.line
    opacity: enabled ? 1 : 0.5
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    RowLayout {
        id: row
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
            topMargin: 10
            bottomMargin: 10
        }
        spacing: 10

        // Round icon well
        Rectangle {
            implicitWidth: 32
            implicitHeight: 32
            radius: 16
            color: root.on ? Qt.rgba(0, 0, 0, 0.12) : Theme.card

            Icon {
                anchors.centerIn: parent
                name: root.icon
                color: root.on ? Theme.accentText : Theme.text
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

            Text {
                Layout.fillWidth: true
                text: root.label
                elide: Text.ElideRight
                color: root.on ? Theme.accentText : Theme.text
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSize
                    weight: Font.DemiBold
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.detail
                elide: Text.ElideRight
                color: root.on ? Theme.accentText : Theme.muted
                opacity: root.on ? 0.72 : 1
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
