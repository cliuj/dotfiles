import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Card {
    id: root
    spacing: 10

    readonly property bool hasPlayer: Media.player !== null

    // Round button with an icon; the play/pause one is larger and filled
    component ControlButton: Rectangle {
        id: button
        required property string icon
        property bool primary: false
        property bool active: false
        signal clicked

        implicitWidth: primary ? 36 : 30
        implicitHeight: implicitWidth
        radius: implicitWidth / 2
        color: primary ? Theme.accent : buttonArea.containsMouse ? Theme.card : "transparent"

        Icon {
            anchors.centerIn: parent
            name: button.icon
            size: button.primary ? 16 : 15
            color: button.primary ? Theme.accentText : button.active ? Theme.accent : Theme.text
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    // Art and track text
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        ClippingRectangle {
            implicitWidth: 52
            implicitHeight: 52
            radius: 10
            color: Theme.accentSoft

            // Shown until the art loads, and when there is no art
            Icon {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                name: "music"
                size: 22
                color: Theme.accent
            }

            Image {
                id: art
                anchors.fill: parent
                source: Media.player?.trackArtUrl ?? ""
                sourceSize: Qt.size(104, 104)       // 2x for a sharp image
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: root.hasPlayer ? (Media.player.trackTitle || "Unknown title") : "Nothing playing"
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
                text: root.hasPlayer ? [Media.player.trackArtist, Media.playerName].filter(s => s).join(" \u00b7 ") : "Click to open " + Media.sources[0].name
                color: Theme.muted
                font {
                    family: Theme.font
                    pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }

    // Progress bar; click or drag to seek
    Item {
        id: seekBar
        visible: root.hasPlayer
        Layout.fillWidth: true
        implicitHeight: 12      // Taller than the bar, so it's easier to click on

        readonly property bool active: seekArea.containsMouse || seekArea.pressed
        // While dragging, show where you drag instead of the player's position
        readonly property real shown: seekArea.pressed ? seekArea.fraction : Media.progress

        // Track and fill; thicker while hovered
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: seekBar.active ? 5 : 3
            radius: height / 2
            color: Theme.line
            Behavior on height {
                NumberAnimation {
                    duration: 120
                }
            }

            Rectangle {
                width: parent.width * seekBar.shown
                height: parent.height
                radius: parent.radius
                color: Theme.accent
            }
        }

        // Knob only while hovered
        Rectangle {
            visible: seekBar.active && Media.canSeek
            anchors.verticalCenter: parent.verticalCenter
            x: seekBar.shown * seekBar.width - width / 2
            width: 10
            height: 10
            radius: 5
            color: Theme.accent
        }

        MouseArea {
            id: seekArea
            property real fraction: 0

            function fractionAt(x) {
                return Math.max(0, Math.min(1, x / width));
            }

            anchors.fill: parent
            enabled: Media.canSeek
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: mouse => fraction = fractionAt(mouse.x)
            onPositionChanged: mouse => {
                if (pressed) {
                    fraction = fractionAt(mouse.x);
                }
            }
            onReleased: Media.seekTo(fraction)
        }
    }

    // Shuffle, Previous, play/pause, next, repeat
    RowLayout {
        visible: root.hasPlayer
        Layout.alignment: Qt.AlignHCenter
        spacing: 16

        ControlButton {
            visible: Media.canShuffle
            icon: "shuffle"
            active: Media.shuffling
            onClicked: Media.toggleShuffle()
        }

        ControlButton {
            icon: "skip-back"
            onClicked: Media.previous()
        }

        ControlButton {
            primary: true
            icon: Media.player?.isPlaying ? "pause" : "play"
            onClicked: Media.togglePlaying()
        }

        ControlButton {
            icon: "skip-forward"
            onClicked: Media.next()
        }

        ControlButton {
            visible: Media.canLoop
            icon: Media.loopingTrack ? "repeat-1" : "repeat"
            active: Media.looping
            onClicked: Media.cycleLoop()
        }
    }

    // Empty state: a click anywhere on the card opens the player
    TapHandler {
        enabled: !root.hasPlayer
        onTapped: Media.launch()
    }

    HoverHandler {
        enabled: !root.hasPlayer
        cursorShape: Qt.PointingHandCursor
    }
}
