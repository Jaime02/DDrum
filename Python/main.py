
import os
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from autogen.settings import url, import_paths

import audioengine
import waveformitem

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    if '__compiled__' in globals():
        # required when deployed with pyside6-deploy
        app_dir = Path(__file__).parent
    else:
        app_dir = Path(__file__).parent.parent

    print(f"app_dir: {app_dir}")

    engine.addImportPath(str(app_dir))
    for path in import_paths:
        engine.addImportPath(str(app_dir / path))

    engine.load(str(app_dir / url))
    if not engine.rootObjects():
        sys.exit(-1)

    ex = app.exec()
    del engine
    return ex

if __name__ == '__main__':
    sys.exit(main())
