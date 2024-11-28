# Copyright (C) 2024 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QDirIterator

# The .qrc resource file is compiled by Qt Design Studio to resources.py
# NOTE: When the resource content changes, the file needs to be recompiled again
import autogen.resources  # noqa: E402

# TODO: check how to avoid this imports or generate them in DS
import audioengine  # noqa: E402
import waveformitem  # noqa: E402


def main():
    qml_app_url = ":/qt/qml/DDrumContent/App.qml"

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
