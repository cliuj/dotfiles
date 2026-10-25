import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root
    default property alias content: column.data
    property int padding: 12
    property alias spacing: column.spacing

    implicitWidth: column.implicitWidth + padding * 2
    implicitHeight: column.implicitHeight + padding * 2
    radius: Theme.radiusCard
    color: Theme.card
    border.width: 1
    border.color: Theme.line

    ColumnLayout {
        id: column
        anchors {
            fill: parent
            margins: root.padding
        }
    }
}
