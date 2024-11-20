from PySide6.QtQml import QmlElement
from PySide6.QtCore import Qt, QObject, Slot, Property, Signal, QUrl
from PySide6.QtMultimedia import QSoundEffect

QML_IMPORT_NAME = "Audio"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class AudioEngine(QObject):

    volumeChanged = Signal()
    fileChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._sound = QSoundEffect()
        self._sound.setSource(QUrl.fromLocalFile(":/Sounds/Blow.wav"))

    @Slot(result=None)
    def play(self):
        self._sound.play()

    def volume(self):
        return self._sound.volume()

    def setVolume(self, value):
        self._sound.setVolume(value)
        self.volumeChanged.emit()

    def file(self):
        return self._sound.source()

    def setFile(self, value: QUrl):
        if self._sound.source() == value:
            return

        self._sound.setSource(value.toString())
        self.fileChanged.emit()

    volume = Property(float, volume, setVolume, notify=volumeChanged)
    file = Property(QUrl, file, setFile, notify=fileChanged)
