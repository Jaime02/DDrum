import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import Components

ComboBox {
    id: root

    property string currentFile: currentText ? `Sounds/${currentText}` : ""

    AudioFilesModel {
        id: audioFilesModel
    }

    model: audioFilesModel.getModel()

    contentItem: Text {
        leftPadding: 0
        rightPadding: root.spacing

        text: root.displayText
        color: root.pressed ? "#090909" : "black"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
