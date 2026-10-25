import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

PanelWindow {
    id: root
    required property ShellScreen modelData
    screen: modelData

    readonly property bool open: Panels.current === "qs" && Panels.screen === modelData

    anchors {
        top: true
        right: true
    }
    margins.right: Theme.gap
    exclusionMode: ExclusionMode.Normal   // starts below the bar
    implicitWidth: 380
    implicitHeight: card.implicitHeight + Theme.gap
    color: "transparent"
    // Stay mapped until the fade-out finishes
    visible: open || card.opacity > 0

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-quicksettings"
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    mask: Region {
        item: card
    }
    BackgroundEffect.blurRegion: Region {
        item: card
        radius: Theme.radiusPanel
    }

    Rectangle {
        id: card
        y: Theme.gap
        width: parent.width
        implicitHeight: content.implicitHeight + 28
        radius: Theme.radiusPanel
        color: Theme.glass
        border.width: 1
        border.color: Theme.line
        transformOrigin: Item.TopRight

        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.97
        transform: Translate {
            y: root.open ? 0 : -16
            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Theme.curve
                }
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.curve
            }
        }

        focus: true
        // Esc and Enter go to the confirm dialog while it is open
        Keys.onEscapePressed: confirmDialog.open ? confirmDialog.cancel() : Panels.close()
        Keys.onReturnPressed: {
            if (confirmDialog.open) {
                confirmDialog.accept();
            }
        }

        ColumnLayout {
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 14
            }
            spacing: 12

            UserRow {
                Layout.fillWidth: true
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 8
                rowSpacing: 8

                ToggleTile {
                    icon: Radios.wifiOn ? "wifi" : "wifi-off"
                    label: "Wi-Fi"
                    on: Radios.wifiOn
                    detail: !Radios.wifiOn ? "Off" : Radios.ssid || "Not connected"
                    onClicked: Radios.toggleWifi()
                }

                ToggleTile {
                    icon: Radios.btOn ? "bluetooth" : "bluetooth-off"
                    label: "Bluetooth"
                    on: Radios.btOn
                    enabled: Radios.btAvailable
                    detail: !Radios.btAvailable ? "Unavailable" : !Radios.btOn ? "Off" : Radios.btConnected + " connected"
                    onClicked: Radios.toggleBluetooth()
                }

                ToggleTile {
                    icon: "coffee"
                    label: "Caffeine"
                    on: Caffeine.on
                    detail: Caffeine.on ? "Idle blocked" : "Off"
                    onClicked: Caffeine.toggle()
                }
                ToggleTile {
                    icon: "plane"
                    label: "Airplane"
                    on: Radios.airplane
                    detail: Radios.airplane ? "On" : "Off"
                    onClicked: Radios.toggleAirplane()
                }
                ToggleTile {
                    icon: "moon"
                    label: "Night light"
                    on: NightLight.on
                    detail: NightLight.on ? NightLight.temperature + "K" : "Off"
                    onClicked: NightLight.toggle()
                }
            }

            // Sliders on the left, battery on the right
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Card {
                    Layout.fillHeight: true
                    RowLayout {
                        Layout.fillHeight: true
                        spacing: 14

                        VSlider {
                            visible: Brightness.available
                            icon: "sun"
                            tooltip: "Brightness"
                            value: Brightness.value
                            onMoved: v => Brightness.set(v)
                        }

                        VSlider {
                            icon: Audio.icon
                            tooltip: "Volume \u00b7 " + Audio.deviceName
                            value: Audio.volume
                            onMoved: v => Audio.setVolume(v)
                            onIconClicked: Audio.toggleMute()
                        }
                    }
                }

                BatteryCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
            MediaCard {
                Layout.fillWidth: true
            }
            PowerBar {
                Layout.fillWidth: true
                onConfirm: action => confirmDialog.action = action
            }
        }

        // Above the panel content
        ConfirmDialog {
            id: confirmDialog
            anchors.fill: parent
        }
    }
}
