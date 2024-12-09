qt_add_library(components STATIC)
qt6_add_qml_module(components
    URI Components
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    SOURCES
        "audiofilesmodel.h"
        "audiofilesmodel.cpp"
)
