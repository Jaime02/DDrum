from PySide6.QtCore import Qt, Property, QUrl, Signal
from PySide6.QtGui import QColor
from PySide6.QtQml import QmlElement
from PySide6.QtQuick import QQuickPaintedItem
from PySide6.QtMultimedia import QAudioFormat, QAudioDecoder, QAudioBuffer

QML_IMPORT_NAME = "Audio"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class WaveformItem(QQuickPaintedItem):

    fileChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._waveformData = []

        format = QAudioFormat()
        format.setChannelCount(1)
        format.setSampleRate(44100)
        format.setSampleFormat(QAudioFormat.Float)

        self._decoder = QAudioDecoder()
        self._decoder.setAudioFormat(format)
        self._decoder.setSource(QUrl.fromLocalFile("../Sounds/Blow.wav"))
        self._decoder.bufferReady.connect(self.onBufferReady)

    def file(self):
        return self._decoder.source()

    def setFile(self, value):
        if self._decoder.source() == value:
            return
        self._decoder.setSource(value)
        self.fileChanged.emit()

    def paint(self, painter):
        painter.setPen(Qt.black)
        if len(self._waveformData) == 0:
            painter.fillRect(self.boundingRect(), Qt.red)
        else:
            painter.fillRect(self.boundingRect(), Qt.magenta)
        painter.drawText(self.boundingRect(), Qt.AlignCenter, "Python: Waveform")

    def onBufferReady(self):
        buffer = self._decoder.read()
        data = buffer.constData()
        for i in range(0, buffer.frameCount()):
            self._waveformData.append(data[i])
        self.update()


    file = Property(QUrl, file, setFile, notify=fileChanged)
