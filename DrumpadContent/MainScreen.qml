/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Drumpad
import Audio
import QtQuick.Layouts

Rectangle {
    id: root

    property QtObject soundEffectPlayer: Qt.createComponent("../Drumpad/SoundEffectPlayer.qml", Component.PreferSynchronous)

    color: "black"
    focus: true

    Component.onCompleted: {
        // Initialize initial sound effect players
        for (var i = 0; i < audioPlayersSpinBox.value; i++) {
            root.soundEffectPlayer.createObject(soundEffectPlayersFlow, {
                index: i
            });
        }
    }
    Keys.onPressed: event => {
        if (event.key < Qt.Key_1 || event.key > Qt.Key_9) {
            // Ignore key out of scope
            return;
        }

        let digit = event.key - Qt.Key_1;
        if (digit < soundEffectPlayersFlow.children.length) {
            soundEffectPlayersFlow.children[digit].play();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Row {
            id: audioPlayersCountRow

            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                text: "Audio players:"
            }
            StyledSpinBox {
                id: audioPlayersSpinBox

                value: 5

                onValueModified: {
                    if (audioPlayersSpinBox.value < soundEffectPlayersFlow.children.length) {
                        // Remove extra sound effect players
                        soundEffectPlayersFlow.children.length = audioPlayersSpinBox.value;
                        return;
                    }

                    if (audioPlayersSpinBox.value > soundEffectPlayersFlow.children.length) {
                        // Create more sound effect players
                        for (var i = soundEffectPlayersFlow.children.length; i < audioPlayersSpinBox.value; i++) {
                            root.soundEffectPlayer.createObject(soundEffectPlayersFlow, {
                                index: i
                            });
                        }
                        return;
                    }
                }
            }
        }
        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            contentWidth: width

            background: Rectangle {
                color: "#232323"
            }

            CenteredFlow {
                id: soundEffectPlayersFlow

                anchors.fill: parent
                padding: 10
                spacing: 10
            }
        }
    }
}
