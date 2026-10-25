import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root
    // Children placed inside an Island go into the row.
    default property alias content: row.data
    property int padding: 12

    property bool clickable: false
    property bool active: false
    signal clicked

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: 38
    radius: Theme.radiusIsland
    color: Theme.glass
    border.width: 1
    border.color: active ? Theme.accent : Theme.line

    // Inner 1px ring when active
    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }
        radius: root.radius - 1
        color: "transparent"
        border.width: 1
        border.color: Theme.accent
        visible: root.active
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.clickable
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10
    }
}
