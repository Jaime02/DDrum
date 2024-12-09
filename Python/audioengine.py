from typing import Optional

from PySide6.QtQml import QmlElement
from PySide6.QtCore import QObject, Slot, Property, Signal, QUrl
from PySide6.QtMultimedia import QSoundEffect

from autogen.settings import project_root

QML_IMPORT_NAME = "Audio"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class AudioEngine(QObject):
    volumeChanged = Signal()
    fileChanged = Signal()
    isPlayingChanged = Signal()
    decodingStatus = Signal(QSoundEffect.Status, str)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._sound = QSoundEffect()
        self._sound.playingChanged.connect(self.isPlayingChanged.emit)#
        self._sound.statusChanged.connect(self.reportStatus)

    def reportStatus(self):
        if self._sound.status() == QSoundEffect.Status.Error:
            self.decodingStatus.emit(QSoundEffect.Status.Error, f"Error decoding file: {self._sound.source().path()}")
        else:
            self.decodingStatus.emit(self._sound.status(), "")

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
        if self._sound.source() == value or value.isEmpty():
            return

        if "__compiled__" in globals():
            self._sound.setSource(f"qrc:/{value.toString()}")
        else:
            self._sound.setSource(f"file:{project_root / value.toString()}")
        self.fileChanged.emit()

    def isPlaying(self):
        # print("Isplaying", self._sound.isPlaying())
        return self._sound.isPlaying()


    volume = Property(float, volume, setVolume, notify=volumeChanged)
    file = Property(QUrl, file, setFile, notify=fileChanged)
    isPlaying = Property(bool, isPlaying, notify=isPlayingChanged)
