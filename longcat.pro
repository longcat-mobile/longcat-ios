TEMPLATE = app
TARGET = longcat

QT += quick quickcontrols2 sql multimedia
CONFIG += c++17

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

SOURCES += \
    src/main.cpp

HEADERS += \
    src/admobhelper.h \
    src/gamecenterhelper.h \
    src/reachabilityhelper.h \
    src/sharehelper.h \
    src/storehelper.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

TRANSLATIONS += \
    translations/longcat_ja.ts \
    translations/longcat_ru.ts

QMAKE_CFLAGS += $$(QMAKE_CFLAGS_ENV)
QMAKE_CXXFLAGS += $$(QMAKE_CXXFLAGS_ENV)
QMAKE_LFLAGS += $$(QMAKE_LFLAGS_ENV)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    CONFIG += qtquickcompiler

    INCLUDEPATH += ios/frameworks
    DEPENDPATH += ios/frameworks

    OBJECTIVE_SOURCES += \
        src/admobhelper.mm \
        src/gamecenterhelper.mm \
        src/reachabilityhelper.mm \
        src/sharehelper.mm \
        src/storehelper.mm

    LIBS += -F $$PWD/ios/frameworks \
            -framework GoogleAppMeasurement \
            -framework GoogleMobileAds \
            -framework GoogleUtilities \
            -framework UserMessagingPlatform \
            -framework PromisesObjC \
            -framework nanopb \
            -framework JavaScriptCore \
            -framework Foundation \
            -framework UIKit \
            -framework StoreKit \
            -framework GameKit

    QMAKE_OBJECTIVE_CFLAGS += $$(QMAKE_OBJECTIVE_CFLAGS_ENV)
    QMAKE_LFLAGS += -ObjC

    IOS_SIGNATURE_TEAM.name = "Oleg Derevenets"
    IOS_SIGNATURE_TEAM.value = 87JNRRMN2P

    QMAKE_MAC_XCODE_SETTINGS += IOS_SIGNATURE_TEAM

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
    QMAKE_IOS_DEPLOYMENT_TARGET = 12.0
    QMAKE_TARGET_BUNDLE_PREFIX = "com.derevenetz.oleg"
}
