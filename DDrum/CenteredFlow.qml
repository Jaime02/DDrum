import QtQuick

Flow {
    property int rowCount: parent.width / (children[0].width + spacing)
    property int rowWidth: rowCount * children[0].width + (rowCount - 1) * spacing
    property int margin: children[0].width + spacing <= parent.width ? (parent.width - rowWidth) / 2 : 0
    anchors {
        leftMargin: margin
        rightMargin: margin
    }
}