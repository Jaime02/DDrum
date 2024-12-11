import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Dialogs
import QtMultimedia

import DDrum
import Audio

Rectangle {
    id: root

    property string decodingError: ""
    required property int index
    property int status: SoundEffect.Null

    function play() {
        if (root.status == SoundEffect.Ready) {
            audioEngine.play();
        }
    }

    color: Constants.darkGray
    implicitHeight: layout.implicitHeight + 2 * layout.anchors.margins
    implicitWidth: layout.implicitWidth + 2 * layout.anchors.margins
    radius: 10

    onDecodingErrorChanged: {
        if (status == SoundEffect.Error && root.decodingError) {
            errorMessageDialog.text = root.decodingError;
            errorMessageDialog.open();
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        AudioEngine {
            id: audioEngine

            file: availableSoundsComboBox.currentFile
            volume: volumeSlider.value

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
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "white"
                text: `Player ${root.index + 1}`
            }
            AvailableSoundsComboBox {
                id: availableSoundsComboBox

                Layout.alignment: Qt.AlignCenter
                initialIndex: root.index
            }
        }
        WaveformItem {
            id: waveformItem

            file: audioEngine.file
            height: 100
            width: 300
        }
        Row {
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Rectangle {
                id: padRectangle

                color: "transparent"
                height: 100
                width: 100

                Shape {
                    anchors.fill: padRectangle

                    ShapePath {
                        strokeColor: "black"
                        strokeWidth: 2

                        fillGradient: RadialGradient {
                            centerRadius: padRectangle.height
                            centerX: padRectangle.width / 2
                            centerY: padRectangle.height / 2
                            focalX: centerX
                            focalY: centerY

                            GradientStop {
                                color: {
                                    if (root.status == SoundEffect.Error || root.status == SoundEffect.Null) {
                                        return "black";
                                    }

                                    if (root.status == SoundEffect.Loading) {
                                        return "yellow";
                                    }
                                    return audioEngine.isPlaying ? Qt.darker(Constants.primaryColor, 1.25) : Qt.darker(Constants.secondaryColor, 1.25);
                                }
                                position: 0
                            }
                            GradientStop {
                                color: {
                                    if (root.status == SoundEffect.Error || root.status == SoundEffect.Null) {
                                        return Constants.darkGray;
                                    }
                                    if (root.status == SoundEffect.Loading) {
                                        return "orange";
                                    }
                                    return audioEngine.isPlaying ? Constants.primaryColor : Constants.secondaryColor;
                                }
                                position: 0.5
                            }
                        }

                        // Rounded shape path
                        PathMove {
                            x: 10
                            y: 0
                        }
                        PathQuad {
                            controlX: 0
                            controlY: 0
                            x: 0
                            y: 10
                        }
                        PathLine {
                            x: 0
                            y: padRectangle.height - 10
                        }
                        PathQuad {
                            controlX: 0
                            controlY: padRectangle.height
                            x: 10
                            y: padRectangle.height
                        }
                        PathLine {
                            x: padRectangle.width - 10
                            y: padRectangle.height
                        }
                        PathQuad {
                            controlX: padRectangle.width
                            controlY: padRectangle.height
                            x: padRectangle.width
                            y: padRectangle.height - 10
                        }
                        PathLine {
                            x: padRectangle.width
                            y: 10
                        }
                        PathQuad {
                            controlX: padRectangle.width
                            controlY: 0
                            x: padRectangle.width - 10
                            y: 0
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
                        function onClicked() {
                            root.play();
                        }

                        target: padMouseArea
                    }
                }
            }
            VolumeSlider {
                id: volumeSlider

                height: padRectangle.height
                value: 0.75
                width: 16
            }
        }
    }
}
