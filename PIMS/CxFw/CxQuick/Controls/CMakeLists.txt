set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

add_custom_target(Controls
  SOURCES
    qmldir
    Badge.qml
    Banner.qml
    HomePage.qml
    MainPage.qml
    Popup.qml
    TextField.qml
)

install(FILES
    qmldir
    Badge.qml
    Banner.qml
    HomePage.qml
    MainPage.qml
    Popup.qml
    TextField.qml
  DESTINATION "qml/CxQuick/Controls"
)
