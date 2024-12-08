pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Components

ComboBox {
    id: root

    property string currentFile: currentText ? `Sounds/${currentText}` : ""

    AudioFilesModel {
        id: audioFilesModel
    }

    model: audioFilesModel.getModel()

    background: Rectangle {
        implicitHeight: 30
        color: root.pressed ? "#ac0000" : "black"
        border.color: root.pressed ? "#ff0000" : "#ac0000"
        border.width: root.visualFocus ? 3 : 2
        radius: 2
    }

    indicator: Canvas {
        id: canvas
        x: root.width - canvas.width - root.rightPadding
        y: root.topPadding + (root.availableHeight - canvas.height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: root
            function onPressedChanged() {
                canvas.requestPaint();
            }
        }

        onPaint: {
            let margin = 2;
            context.reset();
            context.lineWidth = 2;
            context.strokeStyle = "white";
            context.lineCap = "round";
            context.beginPath();
            context.moveTo(margin, margin);
            context.lineTo(width / 2, height - margin);
            context.lineTo(width - margin, margin);
            context.stroke();
        }
    }

    contentItem: Text {
        color: "white"
        leftPadding: 10
        rightPadding: root.indicator.width + 10
        text: root.displayText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    popup: Popup {
        id: popup
        y: root.height
        implicitWidth: 300
        implicitHeight: contentItem.implicitHeight
        padding: 0
        contentItem: ListView {
            model: popup.visible ? root.model : null
            clip: true
            implicitHeight: Math.min(contentHeight, 200)
            currentIndex: root.highlightedIndex
            ScrollIndicator {
                id: scrollIndicator
            }
            ScrollIndicator.vertical: height < contentHeight ? scrollIndicator : null

            delegate: ItemDelegate {
                id: itemDelegate
                required property int index
                contentItem: Text {
                    text: root.model[index]
                    anchors.fill: parent
                    color: "white"
                    // color: highlighted ? "#ff0000" : "white"
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "black"
                    implicitWidth: contentItem.implicitWidth
                }
            }
        }

        background: Rectangle {
            color: "black"
            border.color: "#ff0000"
        }
    }
}
