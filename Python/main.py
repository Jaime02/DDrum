import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from autogen.settings import setup_qt_environment
from audio import *  # noqa: F401,F403


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    setup_qt_environment(engine)

    if not engine.rootObjects():
        sys.exit(-1)

    ex = app.exec()
    del engine
    return ex


if __name__ == "__main__":
    sys.exit(main())
