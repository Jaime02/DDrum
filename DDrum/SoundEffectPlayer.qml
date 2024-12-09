import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Dialogs
import QtMultimedia

import DDrum
import Audio

Rectangle {
    id: root

    required property int index
    property int status: SoundEffect.Null
    property string decodingError: ""

    color: Constants.darkGray
    radius: 10
    implicitWidth: layout.implicitWidth + 2 * layout.anchors.margins
    implicitHeight: layout.implicitHeight + 2 * layout.anchors.margins

    ColumnLayout {
        id: layout
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10

        AudioEngine {
            id: audioEngine
            volume: volumeSlider.value
            file: availableSoundsComboBox.currentFile

            onDecodingStatusChanged: (status, error) => {
                root.status = status;
                if (status == SoundEffect.Error && error) {
                    root.decodingError = error;
                } else {
                    root.decodingError = "";
                }
            }
        }

        MessageDialog {
            id: errorMessageDialog
            buttons: MessageDialog.Ok
            title: "Error decoding file"
        }

        RowLayout {
            spacing: 10

            Text {
                text: `Player ${root.index + 1}`
                color: "white"
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            AvailableSoundsComboBox {
                id: availableSoundsComboBox
                Layout.alignment: Qt.AlignCenter
            }
        }

        WaveformItem {
            id: waveformItem
            file: audioEngine.file
            width: 300
            height: 100
        }

        Row {
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Rectangle {
                id: padRectangle
                color: "transparent"
                width: 100
                height: 100
                radius: 10
                border.width: 2

                Shape {
                    anchors.fill: padRectangle
                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "black"
                        fillGradient: RadialGradient {
                            centerX: padRectangle.width / 2
                            centerY: padRectangle.height / 2
                            focalX: centerX
                            focalY: centerY
                            centerRadius: padRectangle.height
                            GradientStop {
                                position: 0
                                color: root.status != SoundEffect.Ready ? "black" : audioEngine.isPlaying ? Qt.darker(Constants.primaryColor, 1.25) : Qt.darker(Constants.secondaryColor, 1.25)
                            }
                            GradientStop {
                                position: 0.5
                                color: root.status != SoundEffect.Ready ? Constants.darkGray : audioEngine.isPlaying ? Constants.primaryColor : Constants.secondaryColor
                            }
                        }
                        // Rounded shape path
                        PathMove {
                            x: 10
                            y: 0
                        }
                        PathQuad {
                            x: 0
                            y: 10
                            controlX: 0
                            controlY: 0
                        }
                        PathLine {
                            x: 0
                            y: padRectangle.height - 10
                        }
                        PathQuad {
                            x: 10
                            y: padRectangle.height
                            controlX: 0
                            controlY: padRectangle.height
                        }
                        PathLine {
                            x: padRectangle.width - 10
                            y: padRectangle.height
                        }
                        PathQuad {
                            x: padRectangle.width
                            y: padRectangle.height - 10
                            controlX: padRectangle.width
                            controlY: padRectangle.height
                        }
                        PathLine {
                            x: padRectangle.width
                            y: 10
                        }
                        PathQuad {
                            x: padRectangle.width - 10
                            y: 0
                            controlX: padRectangle.width
                            controlY: 0
                        }
                        PathLine {
                            x: 10
                            y: 0
                        }
                    }
                }

                MouseArea {
                    id: padMouseArea
                    anchors.fill: parent
                    Connections {
                        target: padMouseArea
                        function onClicked() {
                            root.play();
                        }
                    }
                }
            }

            VolumeSlider {
                id: volumeSlider
                value: 0.75
                height: padRectangle.height
                width: 16
            }
        }
    }

    onDecodingErrorChanged: {
        if (status == SoundEffect.Error && root.decodingError) {
            errorMessageDialog.text = root.decodingError;
            errorMessageDialog.open();
        }
    }

    function play() {
        if (root.status == SoundEffect.Ready) {
            audioEngine.play();
        }
    }
}
