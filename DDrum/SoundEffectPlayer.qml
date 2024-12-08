import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import DDrum
import Audio


ColumnLayout {
    spacing: 10

    AudioEngine {
        id: audioEngine
        volume: volumeSlider.value
        file: availableSoundsComboBox.currentFile
    }

    AvailableSoundsComboBox {
        id: availableSoundsComboBox
        Layout.alignment: Qt.AlignCenter
    }

    WaveformItem {
        id: waveformItem
        file: audioEngine.file
        width: 300
        height: 100
    }

    Row {
        Layout.alignment: Qt.AlignCenter
        Rectangle {
            id: padRectangle
            width: 100
            height: 100
            color: "#83e178"
            radius: 10
            border.width: 2

            MouseArea {
                id: padMouseArea
                anchors.fill: parent
                Connections {
                    target: padMouseArea
                    function onClicked() {
                        audioEngine.play()
                    }
                }
            }
        }

        Slider {
            id: volumeSlider
            value: 0.75
            orientation: Qt.Vertical
            height: padRectangle.height
        }
    }
}
