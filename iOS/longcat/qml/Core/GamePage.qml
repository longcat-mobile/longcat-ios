import QtQuick 2.9

import "Game"

Item {
    id: gamePage

    property bool appInForeground: Qt.application.active
    property bool pageActive:      false

    onAppInForegroundChanged: {
        if (appInForeground && pageActive) {
        }
    }

    onPageActiveChanged: {
        if (appInForeground && pageActive) {
        }
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:           backgroundImage
            anchors.fill: parent
            source:       "qrc:/resources/images/game/background.png"
            fillMode:     Image.PreserveAspectCrop
        }

        AnimatedLayer {
            id:              cloudsLayer
            anchors.fill:    parent
            z:               1
            movementEnabled: true
            movementSpeed:   1
            imageSource:     "qrc:/resources/images/game/layer_clouds.png"
        }

        AnimatedLayer {
            id:              bushLayer
            anchors.fill:    parent
            z:               2
            movementEnabled: true
            movementSpeed:   2
            imageSource:     "qrc:/resources/images/game/layer_bush.png"
        }

        AnimatedLayer {
            id:              grassLayer
            anchors.fill:    parent
            z:               3
            movementEnabled: true
            movementSpeed:   4
            imageSource:     "qrc:/resources/images/game/layer_grass.png"
        }

        AnimatedLayer {
            id:              groundLayer
            anchors.fill:    parent
            z:               4
            movementEnabled: true
            movementSpeed:   8
            imageSource:     "qrc:/resources/images/game/layer_ground.png"
        }
    }
}
