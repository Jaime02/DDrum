
add_subdirectory(audio)
add_subdirectory(components)

target_sources(${CMAKE_PROJECT_NAME} PUBLIC "main.cpp")
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    audio
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml)
