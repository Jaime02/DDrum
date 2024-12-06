from pathlib import Path

from PySide6.QtCore import QObject, Slot, QDirIterator
from PySide6.QtQml import QmlElement

from autogen.settings import project_root


QML_IMPORT_NAME = "Components"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class AudioFilesModel(QObject):
    @Slot(result=list)
    def getModel(self):
        if "__compiled__" in globals():
            iterator = QDirIterator(":/Sounds", QDirIterator.Subdirectories)
            audio_files = []
            while iterator.hasNext():
                resource = iterator.next()
                audio_files.append(resource.split(":/Sounds/")[-1])
            return audio_files

        return list(p.name for p in Path(project_root / "Sounds").glob("*.wav"))