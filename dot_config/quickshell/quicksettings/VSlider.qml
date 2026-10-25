import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import qs.services
import qs.components

ColumnLayout {
    id: root
    required property string icon
    required property real value      // 0..1
    property string tooltip: ""
    signal moved(real value)
    signal iconClicked

    Layout.fillHeight: true
    spacing: 8

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: Math.round(root.value * 100) + "%"
        color: Theme.text
        font {
            family: Theme.fontMono
            pixelSize: Theme.fontSizeSmall
        }
    }

    Slider {
        id: slider
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true
        Layout.minimumHeight: 120
        implicitWidth: 34          // wider than the track, easier to grab
        orientation: Qt.Vertical
        from: 0
        to: 1
        stepSize: 0.05             // wheel and arrow keys; dragging stays smooth
        wheelEnabled: true
        value: root.value
        onMoved: root.moved(value)

        background: Rectangle {
            x: slider.leftPadding + (slider.availableWidth - width) / 2
            y: slider.topPadding
            width: 6
            height: slider.availableHeight
            radius: 3
            color: Theme.line

            // Filled part, grows from the bottom
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: (1 - slider.visualPosition) * parent.height
                radius: 3
                color: Theme.accent
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + (slider.availableWidth - width) / 2
            y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
            width: 14
            height: 14
            radius: 7
            color: Theme.text
        }
    }

    Icon {
        Layout.alignment: Qt.AlignHCenter
        name: root.icon
        size: 15

        MouseArea {
            id: iconArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.iconClicked()
        }

        ToolTip {
            visible: iconArea.containsMouse && root.tooltip !== ""
            delay: 400
            text: root.tooltip

            contentItem: Text {
                text: root.tooltip
                color: Theme.text
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSizeSmall
                }
            }

            background: Rectangle {
                color: Theme.rgba(10, 15, 32, 0.95)
                radius: 8
                border.width: 1
                border.color: Theme.line
            }
        }
    }
}
