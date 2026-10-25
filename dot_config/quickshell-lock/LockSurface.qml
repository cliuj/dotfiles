pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

// One screen of the lock: wallpaper, clock, password field, power buttons
Item {
    id: root
    required property LockContext context
    required property string screenName

    // Size unit: the mockup was drawn at 1440 px wide
    readonly property real u: Math.max(1, width / 1440)

    // The field, power buttons and dialog show on the primary screen,
    // and also on any screen niri gives the keyboard to
    readonly property bool interactive: screenName === context.primaryName || Window.active

    // Colors from the main shell's Theme.qml
    readonly property color cText: "#e7ecff"
    readonly property color cMuted: "#a3aed0"
    readonly property color cAccent: "#8fb4ff"
    readonly property color cAccentText: "#0b1430"
    readonly property color cWarm: "#f5b86a"
    readonly property color cLine: Qt.rgba(160 / 255, 180 / 255, 1, 0.16)
    readonly property color cCard: Qt.rgba(160 / 255, 180 / 255, 1, 0.07)
    readonly property color cGlass: Qt.rgba(10 / 255, 15 / 255, 32 / 255, 0.6)
    readonly property string font: "JetBrainsMono Nerd Font"

    property date now: new Date()

    Timer {
        running: true
        repeat: true
        interval: 1000
        onTriggered: root.now = new Date()
    }

    // Background: wallpaper, slightly darker, with a fade at the bottom
    Image {
        anchors.fill: parent
        source: "file://" + Quickshell.env("HOME") + "/Pictures/wallpapers/wallhaven-wy6vqx.jpg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: root.width
        asynchronous: true
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.15
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.38
                color: Qt.rgba(10 / 255, 15 / 255, 32 / 255, 0)
            }
            GradientStop {
                position: 0.66
                color: Qt.rgba(10 / 255, 15 / 255, 32 / 255, 0.55)
            }
            GradientStop {
                position: 1
                color: Qt.rgba(10 / 255, 15 / 255, 32 / 255, 0.92)
            }
        }
    }

    // Dims the screen while a power dialog is open
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(5 / 255, 8 / 255, 18 / 255, 0.45)
        visible: root.interactive && root.context.pendingAction !== null

        MouseArea {
            anchors.fill: parent
            onClicked: root.context.cancelAction()
        }
    }

    // Bottom left: clock, lockout notice, password field, status line
    ColumnLayout {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 80 * root.u
            bottomMargin: 72 * root.u
        }
        width: 380 * root.u
        spacing: 22 * root.u

        ColumnLayout {
            spacing: 4 * root.u

            Text {
                text: Qt.formatDateTime(root.now, "HH:mm")
                color: root.cText
                renderType: Text.NativeRendering
                font {
                    family: root.font
                    pixelSize: 112 * root.u
                    weight: Font.Light
                    letterSpacing: -5 * root.u
                }
            }

            Text {
                Layout.leftMargin: 4 * root.u
                text: Qt.formatDateTime(root.now, "ddd d MMM")
                color: root.cMuted
                font {
                    family: root.font
                    pixelSize: 17 * root.u
                    letterSpacing: 1 * root.u
                }
            }
        }

        // faillock notice; it stays until an attempt no longer reports a lock
        Rectangle {
            Layout.fillWidth: true
            visible: root.interactive && root.context.status === "lockout"
            implicitHeight: lockoutRow.implicitHeight + 28 * root.u
            radius: 12 * root.u
            color: Qt.rgba(40 / 255, 30 / 255, 20 / 255, 0.72)
            border.width: 1
            border.color: Qt.rgba(245 / 255, 184 / 255, 106 / 255, 0.5)

            RowLayout {
                id: lockoutRow
                anchors {
                    fill: parent
                    margins: 14 * root.u
                    leftMargin: 16 * root.u
                    rightMargin: 16 * root.u
                }
                spacing: 12 * root.u

                Icon {
                    Layout.alignment: Qt.AlignTop
                    name: "clock"
                    size: 18 * root.u
                    color: root.cWarm
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4 * root.u

                    Text {
                        text: "Account locked"
                        color: root.cWarm
                        font {
                            family: root.font
                            pixelSize: 14 * root.u
                            weight: Font.DemiBold
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        // PAM's own words, including the minutes left
                        text: root.context.statusDetail
                        color: root.cText
                        wrapMode: Text.Wrap
                        lineHeight: 1.3
                        font {
                            family: root.font
                            pixelSize: 13 * root.u
                        }
                    }
                }
            }
        }

        // Password field
        Rectangle {
            Layout.fillWidth: true
            visible: root.interactive
            implicitHeight: 52 * root.u
            radius: 12 * root.u
            color: root.cGlass
            border.width: 1
            border.color: {
                const status = root.context.status;
                if (status === "failed" || status === "lockout" || status === "error")
                    return Qt.rgba(245 / 255, 184 / 255, 106 / 255, 0.75);
                if (root.context.unlockInProgress)
                    return Qt.rgba(143 / 255, 180 / 255, 1, 0.9);
                return Qt.rgba(143 / 255, 180 / 255, 1, 0.55);
            }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 16 * root.u
                    rightMargin: 4 * root.u
                }
                spacing: 8 * root.u

                Icon {
                    name: "lock"
                    size: 16 * root.u
                    color: root.cMuted
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    TextInput {
                        id: passwordInput
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        focus: true
                        clip: true
                        enabled: !root.context.unlockInProgress
                        echoMode: root.context.showPassword ? TextInput.Normal : TextInput.Password
                        inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                        selectByMouse: false
                        color: root.cText
                        font {
                            family: root.font
                            pixelSize: 16 * root.u
                            letterSpacing: root.context.showPassword ? 0 : 3 * root.u
                        }

                        onTextChanged: {
                            if (root.context.currentText !== text)
                                root.context.currentText = text;
                        }

                        // Enter only unlocks; it never confirms a power dialog
                        onAccepted: root.context.tryUnlock()

                        Keys.onEscapePressed: {
                            if (root.context.pendingAction !== null)
                                root.context.cancelAction();
                            else
                                root.context.currentText = "";
                        }

                        // Keep every screen's field in step with the shared text
                        Connections {
                            target: root.context

                            function onCurrentTextChanged() {
                                if (passwordInput.text !== root.context.currentText)
                                    passwordInput.text = root.context.currentText;
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: passwordInput.text === ""
                        text: "Password"
                        color: root.cMuted
                        font {
                            family: root.font
                            pixelSize: 16 * root.u
                        }
                    }
                }

                // Show/hide password; a MouseArea does not take focus from the field
                Rectangle {
                    implicitWidth: 44 * root.u
                    implicitHeight: 44 * root.u
                    radius: 9 * root.u
                    color: eyeArea.containsMouse ? root.cLine : "transparent"

                    Icon {
                        anchors.centerIn: parent
                        name: root.context.showPassword ? "eye-off" : "eye"
                        size: 18 * root.u
                        color: root.context.showPassword ? root.cAccent : root.cMuted
                    }

                    MouseArea {
                        id: eyeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.context.showPassword = !root.context.showPassword
                    }
                }
            }
        }

        // Status line under the field
        Text {
            Layout.fillWidth: true
            Layout.topMargin: -10 * root.u
            Layout.leftMargin: 4 * root.u
            visible: root.interactive
            wrapMode: Text.Wrap
            font {
                family: root.font
                pixelSize: 13 * root.u
            }
            text: {
                const status = root.context.status;
                if (root.context.unlockInProgress)
                    return "Checking…";
                if (status === "failed")
                    return "Wrong password \u00B7" + root.context.failures + "/" + root.context.denyLimit + " attempts";
                if (status === "error")
                    return "Authentication error. " + root.context.statusDetail;
                if (status === "lockout")
                    return Quickshell.env("USER") + " · locked out";
                return Quickshell.env("USER") + " · Enter to unlock";
            }
            color: {
                if (root.context.unlockInProgress)
                    return root.cAccent;
                const status = root.context.status;
                return status === "failed" || status === "error" ? root.cWarm : root.cMuted;
            }
        }
    }

    // Bottom right: round power buttons with labels
    RowLayout {
        id: powerRow
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 80 * root.u
            bottomMargin: 72 * root.u
        }
        visible: root.interactive
        spacing: 14 * root.u

        Repeater {
            model: root.context.actions

            ColumnLayout {
                id: action
                required property var modelData
                readonly property bool picked: root.context.pendingAction?.id === modelData.id

                Layout.preferredWidth: 64 * root.u
                spacing: 8 * root.u

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 52 * root.u
                    implicitHeight: 52 * root.u
                    radius: width / 2
                    color: buttonArea.containsMouse ? Qt.rgba(30 / 255, 40 / 255, 70 / 255, 0.75) : root.cGlass
                    border.width: action.picked ? 2 : 1
                    border.color: {
                        if (action.picked)
                            return action.modelData.warm ? root.cWarm : root.cAccent;
                        return action.modelData.warm ? Qt.rgba(245 / 255, 184 / 255, 106 / 255, 0.35) : root.cLine;
                    }

                    Icon {
                        anchors.centerIn: parent
                        name: action.modelData.icon
                        size: 20 * root.u
                        color: action.modelData.warm ? root.cWarm : root.cText
                    }

                    MouseArea {
                        id: buttonArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.context.ask(action.modelData)
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: action.modelData.label
                    color: root.cMuted
                    font {
                        family: root.font
                        pixelSize: 11 * root.u
                    }
                }
            }
        }
    }

    // Confirm dialog, above the power buttons
    Rectangle {
        anchors {
            right: parent.right
            bottom: powerRow.top
            rightMargin: 80 * root.u
            bottomMargin: 24 * root.u
        }
        visible: root.interactive && root.context.pendingAction !== null
        width: 360 * root.u
        implicitHeight: dialogColumn.implicitHeight + 44 * root.u
        radius: 16 * root.u
        color: Qt.rgba(10 / 255, 15 / 255, 32 / 255, 0.92)
        border.width: 1
        border.color: root.cLine

        // Stops clicks on the dialog from reaching the dimming layer
        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            id: dialogColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 22 * root.u
            }
            spacing: 10 * root.u

            Text {
                text: root.context.pendingAction?.title ?? ""
                color: root.cText
                font {
                    family: root.font
                    pixelSize: 16 * root.u
                    weight: Font.DemiBold
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.context.pendingAction?.text ?? ""
                color: root.cMuted
                wrapMode: Text.Wrap
                lineHeight: 1.3
                font {
                    family: root.font
                    pixelSize: 13 * root.u
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 8 * root.u
                spacing: 10 * root.u

                DialogButton {
                    label: "Cancel"
                    hint: "Esc"
                    onClicked: root.context.cancelAction()
                }

                DialogButton {
                    label: root.context.pendingAction?.label ?? ""
                    filled: true
                    fill: root.context.pendingAction?.warm ? root.cWarm : root.cAccent
                    onClicked: root.context.confirmAction()
                }
            }
        }
    }

    component DialogButton: Rectangle {
        id: dialogButton
        property string label
        property string hint: ""
        property bool filled: false
        property color fill: root.cWarm
        signal clicked

        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: 44 * root.u
        radius: 10 * root.u
        color: filled ? fill : dialogArea.containsMouse ? root.cLine : root.cCard
        border.width: filled ? 0 : 1
        border.color: root.cLine

        RowLayout {
            anchors.centerIn: parent
            spacing: 6 * root.u

            Text {
                text: dialogButton.label
                color: dialogButton.filled ? root.cAccentText : root.cText
                font {
                    family: root.font
                    pixelSize: 13 * root.u
                    weight: Font.DemiBold
                }
            }

            Text {
                visible: dialogButton.hint !== ""
                text: dialogButton.hint
                color: root.cMuted
                font {
                    family: root.font
                    pixelSize: 11 * root.u
                }
            }
        }

        MouseArea {
            id: dialogArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: dialogButton.clicked()
        }
    }
}
