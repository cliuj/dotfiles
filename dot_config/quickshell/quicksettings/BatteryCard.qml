import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Card {
    id: root
    spacing: 10

    // Header: icon, percentage, time against the right edge
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            radius: 20
            color: Theme.card

            Icon {
                anchors.centerIn: parent
                name: Battery.icon
                size: 22
                color: Battery.pluggedIn ? Theme.accent : Battery.low ? Theme.warm : Theme.text
            }
        }

        Text {
            Layout.alignment: Qt.AlignBaseline
            text: Battery.percent + "%"
            color: Theme.text
            font {
                family: Theme.fontMono
                pixelSize: 18
                weight: Font.DemiBold
            }
        }

        Text {
            Layout.alignment: Qt.AlignBaseline
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight
            text: Battery.timeText
            color: Theme.muted
            font {
                family: Theme.font
                pixelSize: Theme.fontSizeSmall
            }
        }
    }

    Text {
        text: "Power profile"
        color: Theme.muted
        font {
            family: Theme.font
            pixelSize: Theme.fontSizeSmall
        }
    }

    // Three-part switch: Saver / Balanced / Performance
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: profileRow.implicitHeight + 6
        radius: 10
        color: Qt.rgba(0, 0, 0, 0.18)
        border.width: 1
        border.color: Theme.line

        RowLayout {
            id: profileRow
            anchors {
                fill: parent
                margins: 3
            }
            spacing: 2

            Repeater {
                model: [
                    {
                        profile: PowerProfile.PowerSaver,
                        icon: "leaf",
                        label: "Saver"
                    },
                    {
                        profile: PowerProfile.Balanced,
                        icon: "gauge",
                        label: "Balanced"
                    },
                    {
                        profile: PowerProfile.Performance,
                        icon: "zap",
                        label: "Performance"
                    }
                ]

                Rectangle {
                    id: option
                    required property var modelData
                    readonly property bool selected: PowerProfiles.profile === modelData.profile
                    readonly property color textColor: selected ? Theme.accentText : optionArea.containsMouse ? Theme.text : Theme.muted

                    // Some laptops have no performance profile
                    visible: modelData.profile !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    implicitHeight: optionColumn.implicitHeight + 11
                    radius: 8
                    color: selected ? Theme.accent : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    ColumnLayout {
                        id: optionColumn
                        anchors.centerIn: parent
                        spacing: 3

                        Icon {
                            Layout.alignment: Qt.AlignHCenter
                            name: option.modelData.icon
                            size: 14
                            color: option.textColor
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: option.modelData.label
                            font {
                                family: Theme.font
                                pixelSize: 11
                            }
                            color: option.textColor
                        }
                    }

                    MouseArea {
                        id: optionArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: PowerProfiles.profile = option.modelData.profile
                    }
                }
            }
        }
    }

    // Charge limit: Icon, label, on/off switch
    RowLayout {
        Layout.fillWidth: true
        visible: Battery.limitSupported
        spacing: 10

        Icon {
            name: "shield-check"
            size: 15
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Text {
                Layout.fillWidth: true
                text: "Charge limit"
                color: Theme.text
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSize
                    weight: Font.Medium
                }
            }
            Text {
                Layout.fillWidth: true
                text: Battery.limitEnabled ? "Stop at " + Battery.limitEnd + "%" : "Charge to 100%"
                color: Theme.muted
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSizeSmall
                }
            }
        }

        // On/off switch
        Rectangle {
            implicitHeight: 20
            implicitWidth: 34
            radius: 10
            color: Battery.limitEnabled ? Theme.accent : Theme.line
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }

            // Knob
            Rectangle {
                y: 3
                x: Battery.limitEnabled ? 17 : 3
                width: 14
                height: 14
                radius: 7
                color: Battery.limitEnabled ? Theme.accentText : Theme.text
                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Theme.curve
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Battery.setLimit(!Battery.limitEnabled)
                }
            }
        }
    }

    // Keeps the rows at the top when the card is taller than its content
    Item {
        Layout.fillHeight: true
    }
}
