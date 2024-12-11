### This file is automatically generated by Qt Design Studio.
### Do not change

add_subdirectory(Drumpad)
add_subdirectory(DrumpadContent)
add_subdirectory(App)

qt6_add_resources(${CMAKE_PROJECT_NAME} MainResource
    PREFIX "/qt/qml"
    VERSION 1.0
    FILES 
        "Sounds/Synth.wav"
        "Sounds/Bass.wav"
        "Sounds/Drum.wav"
        "Sounds/Cowbell.wav"
        "Sounds/Roll.wav"
        "Sounds/Whistle.wav"
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    Drumpadplugin
    DrumpadContentplugin)