/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import DDrum
import Audio
import QtQuick.Layouts

Rectangle {
    id: rectangle

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Row {
            id: audioPlayersCountRow
            spacing: 5
            Text {
                text: "Audio players:"
                anchors.verticalCenter: parent.verticalCenter
            }

            SpinBox {
                id: audioPlayersSpinBox
                value:  4
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            Flow {
                anchors.fill: parent
                spacing: 10
                Repeater {
                    model: audioPlayersSpinBox.value
                    SoundEffectPlayer {
                    }
                }
            }
        }
    }
}
