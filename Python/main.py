import os
import sys
from pathlib import Path

from PySide6.QtCore import QDirIterator
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from autogen.settings import qml_app_url, project_root

import audioengine  # noqa: F401
import waveformitem  # noqa: F401
import audio_files_model  # noqa: F401


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    engine.addImportPath(str(project_root.absolute()))
    if '__compiled__' in globals():
        try:
            import autogen.resources  # noqa: F401
        except ImportError:
            resource_file = Path(__file__).parent / 'autogen' / 'resources.py'
            print(
                f"Error: No compiled resources found in {resource_file.absolute()}\n"
                f"Please compile the resources using pyside6-rcc or pyside6-project build",
                file=sys.stderr,
            )
            sys.exit(1)
        engine.load(qml_app_url)
    else:
        os.environ["QT_QUICK_CONTROLS_CONF"] = str(project_root / "qtquickcontrols2.conf")
        engine.load(str(project_root / qml_app_url))

    if not engine.rootObjects():
        sys.exit(-1)

    ex = app.exec()
    del engine
    return ex


if __name__ == "__main__":
    sys.exit(main())
