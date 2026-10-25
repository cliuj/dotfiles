import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

// Footer: lock, sleep, hibernate, restart, power off
ColumnLayout {
    id: root
    spacing: 12

    // Asks the panel to show the confirm dialog for an action
    signal confirm(var action)

    // Actions with an `ask` field need confirmation first
    readonly property var actions: [
        {
            icon: "lock",
            label: "Lock",
            run: () => Session.lock()
        },
        {
            icon: "moon-star",
            label: "Sleep",
            run: () => Session.suspend()
        },
        {
            icon: "snowflake",
            label: "Hibernate",
            ask: {
                title: "Hibernate now?",
                text: "Saves your session to disk and turns the laptop off. It uses no battery, but waking takes longer than sleep."
            },
            run: () => Session.hibernate()
        },
        {
            icon: "rotate-ccw",
            label: "Restart",
            ask: {
                title: "Restart now?",
                text: "Closes all apps and restarts the laptop. Unsaved work in open apps is lost."
            },
            run: () => Session.reboot()
        },
        {
            icon: "power",
            label: "Power off",
            ask: {
                title: "Power off now?",
                text: "Closes all apps and turns the laptop off. Unsaved work in open apps is lost."
            },
            run: () => Session.powerOff()
        }
    ]

    // Separator line
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: Theme.line
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Repeater {
            model: root.actions

            Rectangle {
                id: button
                required property var modelData
                readonly property bool needsConfirm: modelData.ask !== undefined
                readonly property color contentColor: needsConfirm ? Theme.warm : Theme.text

                // Equal widths
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: buttonColumn.implicitHeight + 15
                radius: 12
                color: buttonArea.containsMouse ? Theme.line : Theme.card
                border.width: 1
                border.color: Theme.line

                ColumnLayout {
                    id: buttonColumn
                    anchors.centerIn: parent
                    spacing: 5

                    Icon {
                        Layout.alignment: Qt.AlignHCenter
                        name: button.modelData.icon
                        size: 16
                        color: button.contentColor
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: button.modelData.label
                        color: button.contentColor
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
                    onClicked: {
                        if (button.needsConfirm) {
                            root.confirm(button.modelData);
                        } else {
                            Panels.close();
                            button.modelData.run();
                        }
                    }
                }
            }
        }
    }
}
