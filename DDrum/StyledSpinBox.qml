import QtQuick
import QtQuick.Controls

SpinBox {
    id: root
    property int innerPadding: 10

    width: contentItem.width + up.indicator.implicitWidth + down.indicator.implicitWidth
    height: contentItem.implicitHeight + innerPadding

    contentItem: Text {
        text: root.textFromValue(root.value, root.locale)
        width: implicitWidth + innerPadding * 2
        height: parent.height
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    up.indicator: Rectangle {
        x: root.mirrored ? 0 : parent.width - width
        implicitWidth: upText.implicitWidth + innerPadding * 2
        height: parent.height
        color: root.up.pressed ? Constants.mediumGray : enabled ? Constants.darkGray : "black"
        border.color: Constants.secondaryColor

        Text {
            id: upText
            text: "+"
            font.pixelSize: Math.round(root.font.pixelSize * 1.5)
            color: "white"
            anchors.fill: parent
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        x: root.mirrored ? parent.width - width : 0
        implicitWidth: downText.implicitWidth + innerPadding * 2
        height: parent.height
        color: root.down.pressed ? Constants.mediumGray : enabled ? Constants.darkGray : "black"
        border.color: Constants.secondaryColor

        Text {
            id: downText
            text: "-"
            font.pixelSize: Math.round(root.font.pixelSize * 1.5)
            color: "white"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        border.color: Constants.secondaryColor
    }
}