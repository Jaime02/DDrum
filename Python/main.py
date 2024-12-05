import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QDirIterator

from autogen.settings import qml_app_url

try:
    import autogen.resources  # noqa: E402
except ImportError:
    print(
        f"Error: No compiled resources found in "
        f"{(Path(__file__) / 'autogen' / 'resources.py').absolute()}",
        f"Please compile the resources using pyside6-rcc or pyside6-project build",
        file=sys.stderr,
    )
    sys.exit(1)

import audioengine  # noqa: E402
import waveformitem  # noqa: E402


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    if True:
        print("Resources found:")
        iterator = QDirIterator(":/", QDirIterator.Subdirectories)
        while iterator.hasNext():
            resource = iterator.next()
            if resource.startswith(":/qt-project.org") or resource.startswith(":/qpdf"):
                continue
            print("Resource:", resource)

    engine.load(qml_app_url)
    if not engine.rootObjects():
        sys.exit(-1)

    ex = app.exec()
    del engine
    return ex


if __name__ == "__main__":
    sys.exit(main())
