cmake_minimum_required(VERSION 3.16)

project(mykde VERSION 0.1)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml QuickControls2 Network Quick)
find_package(KF6 REQUIRED COMPONENTS CoreAddons I18n)

qt_policy(SET QTP0001 NEW)

# Geändert: Das fertige Programm heißt jetzt "mykde-app", um Namenskonflikte zu vermeiden
add_executable(mykde-app main.cpp)

target_link_libraries(mykde-app PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Network
    Qt6::Quick
    KF6::CoreAddons
    KF6::I18n
)

# Das QML-Modul behält seinen Namen bei
qt_add_qml_module(mykde-app
    URI mykde
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml/"
    QML_FILES main.qml
)
