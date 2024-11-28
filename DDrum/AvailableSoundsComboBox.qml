import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

ComboBox {
    id: root

    property string currentFile: currentText ? `qrc:/Sounds/${currentText}` : ""

    FolderListModel {
        id: soundsModel
        folder: "qrc:/Sounds"
        nameFilters: ["*.wav", "*.mp3"]
        onStatusChanged: soundsModel.status == FolderListModel.Ready && soundsModel.count > 0 ? root.currentIndex = 0 : {};
    }

    model: soundsModel

    textRole: "fileName"

    contentItem: Text {
        leftPadding: 0
        rightPadding: root.spacing

        text: root.displayText
        color: root.pressed ? "#090909" : "black"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
