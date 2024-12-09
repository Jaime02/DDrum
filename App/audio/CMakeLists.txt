qt_add_library(audio STATIC)
qt6_add_qml_module(audio
    URI Audio
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    SOURCES
        "audioengine.h"
        "audioengine.cpp"
        "waveformitem.h"
        "waveformitem.cpp"
)

target_link_libraries(audio PRIVATE Qt${QT_VERSION_MAJOR}::Multimedia)
