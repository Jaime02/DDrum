import QtQuick
import QtQuick.Controls

Slider {
    id: root
    orientation: Qt.Vertical
    padding: 0

    background: Rectangle {
        implicitHeight: root.height
        implicitWidth: root.width
        radius: width / 2
        color: Constants.mediumGray

        Rectangle {
            width: parent.width
            height: (1 - root.visualPosition) * parent.height + (root.visualPosition * handle.height)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: Constants.primaryColor
            radius: parent.width / 2
        }
    }

    handle: Rectangle {
        width: root.width
        height: root.width
        x: root.availableWidth / 2 - height / 2
        y: root.visualPosition * (root.availableHeight - height)
        radius: width / 2
        color: root.pressed ? "#e0e0e0" : "#ffffff"
        border.color: "#b0b0b0"
        border.width: 1
    }
}
