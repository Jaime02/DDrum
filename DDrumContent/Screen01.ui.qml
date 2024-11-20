

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

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height

    color: Constants.backgroundColor

    AudioEngine {
        id: audioEngine
        volume: volumeSlider.value
        // Since Screen01.ui.qml uses the /qt/qml prefix path
        // the resource that gets passed to the AudioEngine using the same
        // prefix path which is bad since Fabian said that resources in the root dir
        // should use the / prefix path.
        file: "qrc:/Sounds/roll.wav"
    }

    Rectangle {
        id: rectangle1
        x: 271
        y: 199
        width: 100
        height: 100
        color: "#83e178"
        radius: 10
        border.width: 2

        MouseArea {
            id: mouseArea
            x: 0
            y: 0
            width: 100
            height: 100

            Connections {
                target: mouseArea
                function onClicked() {
                    audioEngine.play()
                }
            }
        }
    }

    Slider {
        id: volumeSlider
        x: 342
        y: 229
        width: 100
        value: 0.5
        rotation: 270
    }

    WaveformItem {
        id: waveformItem
        x: 8
        y: 30
        width: 624
        height: 113
        file: audioEngine.file
    }
}
