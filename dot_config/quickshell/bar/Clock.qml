import Quickshell
import QtQuick
import qs.services
import qs.components


Island {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: Theme.text
        font {
            family: Theme.fontMono;
            pixelSize: 14;
            weight: Font.DemiBold;
        }
    }

    Rectangle {
        implicitWidth: 3;
        implicitHeight: 3;
        radius: 1.5;
        color: Theme.muted;
    }

    Text {
        text: Qt.formatDateTime(clock.date, "ddd d MMM")
        color: Theme.muted
        font {
            family: Theme.font;
            pixelSize: Theme.fontSize;
        }
    }
}
