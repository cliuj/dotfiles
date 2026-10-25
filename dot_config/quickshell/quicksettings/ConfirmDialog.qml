import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

// Dims the panel and asks before hibernate, restart or power off
Item {
    id: root

    property var action: null       // a PowerBar action, or null when closed
    readonly property bool open: action !== null

    function accept() {
        const confirmed = action;
        action = null;
        Panels.close();
        confirmed.run();
    }

    function cancel() {
        action = null;
    }

    visible: opacity > 0
    opacity: open ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    // Close the dialog together with the panel
    Connections {
        target: Panels
        function onCurrentChanged() {
            root.cancel();
        }
    }

    // Button for the dialog; the confirm one is filled with the warm colour
    component DialogButton: Rectangle {
        id: button
        required property string label
        required property string keyHint
        property bool warm: false
        signal clicked

        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: 36
        radius: 10
        color: warm ? Theme.warm : buttonArea.containsMouse ? Theme.line : Theme.card
        border.width: warm ? 0 : 1
        border.color: Theme.line

        RowLayout {
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: button.label
                color: button.warm ? Theme.accentText : Theme.text
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSize
                    weight: Font.DemiBold
                }
            }

            Text {
                text: button.keyHint
                color: button.warm ? Theme.accentText : Theme.muted
                opacity: button.warm ? 0.7 : 1
                font {
                    family: Theme.font
                    pixelSize: 11
                }
            }
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    // Dimmed panel; a click outside the card cancels
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusPanel
        color: Theme.rgba(5, 8, 18, 0.55)

        MouseArea {
            anchors.fill: parent
            onClicked: root.cancel()
        }
    }

    Rectangle {
        id: dialogCard
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 24
        }
        implicitHeight: dialogColumn.implicitHeight + 32
        radius: Theme.radiusPanel
        color: Theme.rgba(14, 20, 40, 0.96)
        border.width: 1
        border.color: Theme.line
        scale: root.open ? 1 : 0.98
        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.curve
            }
        }

        // Keeps clicks on the card from reaching the dimmed area
        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            id: dialogColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 16
            }
            spacing: 12

            RowLayout {
                spacing: 12

                Rectangle {
                    implicitWidth: 40
                    implicitHeight: 40
                    radius: 20
                    color: Theme.warmSoft

                    Icon {
                        anchors.centerIn: parent
                        name: root.action?.icon ?? "power"
                        size: 20
                        color: Theme.warm
                    }
                }

                Text {
                    text: root.action?.ask.title ?? ""
                    color: Theme.text
                    font {
                        family: Theme.font
                        pixelSize: 14
                        weight: Font.DemiBold
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                lineHeight: 1.3
                text: root.action?.ask.text ?? ""
                color: Theme.muted
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSizeSmall
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                DialogButton {
                    label: "Cancel"
                    keyHint: "Esc"
                    onClicked: root.cancel()
                }

                DialogButton {
                    warm: true
                    label: root.action?.label ?? ""
                    keyHint: "\u21b5"
                    onClicked: root.accept()
                }
            }
        }
    }
}
