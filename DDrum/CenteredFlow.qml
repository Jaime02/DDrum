import QtQuick

Flow {
    property int rowCount: children.length ? (parent.width - 2 * padding) / (children[0].width + spacing) : 0
    property int rowWidth: children.length ? rowCount * children[0].width + (rowCount - 1) * spacing + 2 * padding : 0
    property int margin: (children.length && (children[0].width + spacing <= (parent.width - 2 * padding))) ?
                         (parent.width - 2 * padding - rowWidth) / 2 + padding : padding
    anchors {
        leftMargin: margin
        rightMargin: margin
    }
}