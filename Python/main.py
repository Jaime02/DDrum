import subprocess
import logging
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QDirIterator

# Required when running this file from the root project directory
current_dir = Path(__file__).parent
sys.path.append(str(current_dir.absolute()))

from autogen.settings import qml_app_url, import_paths
import audioengine  # noqa: E402
import waveformitem  # noqa: E402

if "__compiled__" in globals():
    project_dir = Path(__file__).parent
else:
    project_dir = Path(__file__).parent.parent

    compiled_resources_file = current_dir / "autogen" / "resources.py"
    if not compiled_resources_file.exists():
        logging.info("Compiled application resources not found. Compiling resources...")

        resource_files = list(project_dir.glob("*.qrc"))
        if not resource_files:
            logging.info("No resources (*.qrc) file found in project root folder. Generate one using Qt Design Studio")
            sys.exit(-1)

        if len(resource_files) > 1:
            logging.error("More than one resources (*.qrc) file found in project root folder. Please merge the resources "
                          "in a single file")
            sys.exit(-1)

        resource_file = resource_files[0]
        subprocess.run(["pyside6-rcc", resource_file, "-o", compiled_resources_file])

import autogen.resources  # noqa: E402

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    engine_paths = {str(project_dir), *[str(project_dir / path) for path in import_paths]}
    for path in engine_paths:
        engine.addImportPath(path)

    # print("QML engine paths:")
    # print(*engine_paths, sep="\n")
    if False:
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


if __name__ == '__main__':
    sys.exit(main())
