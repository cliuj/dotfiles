import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import qs.services
import qs.components

ColumnLayout {
    id: root
    required property string icon
    required property string label
    required property real value      // 0..1
    property string detail: ""

    signal moved(real value)
    signal iconClicked

    Layout.fillWidth: true
    spacing: 6

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Icon {
            name: root.icon
            size: 15
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.iconClicked()
            }
        }

        Text {
            // Fill the row only when there is no detail text
            Layout.fillWidth: root.detail === ""
            text: root.label
            color: Theme.muted
            font {
                family: Theme.font
                pixelSize: Theme.fontSizeSmall
            }
        }

        Rectangle {
            visible: root.detail !== ""
            implicitWidth: 3
            implicitHeight: 3
            radius: 1.5
            color: Theme.muted
        }

        Text {
            visible: root.detail !== ""
            Layout.fillWidth: true
            text: root.detail
            color: Theme.muted
            elide: Text.ElideRight
            font {
                family: Theme.font
                pixelSize: Theme.fontSizeSmall
            }
        }

        Text {
            text: Math.round(root.value * 100) + "%"
            color: Theme.text
            font {
                family: Theme.fontMono
                pixelSize: Theme.fontSizeSmall
            }
        }
    }

    Slider {
        id: slider
        Layout.fillWidth: true
        from: 0
        to: 1
        value: root.value
        onMoved: root.moved(value)

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + (slider.availableHeight - height) / 2
            width: slider.availableWidth
            height: 6
            radius: 3
            color: Theme.line

            // Filled part
            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: 3
                color: Theme.accent
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + (slider.availableHeight - height) / 2
            width: 14
            height: 14
            radius: 7
            color: Theme.text
        }
    }
}
