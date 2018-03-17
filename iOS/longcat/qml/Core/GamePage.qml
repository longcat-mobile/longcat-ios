import QtQuick 2.9

import "Game"

Item {
    id: gamePage

    property bool appInForeground: Qt.application.active
    property bool pageActive:      false
    property bool gamePaused:      !appInForeground || !pageActive

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

            property bool geometrySettled: false

            property real imageScale:      sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

            onPaintedWidthChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    width  = Math.floor(paintedWidth);
                    height = Math.floor(paintedHeight);
                }
            }

            onPaintedHeightChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    width  = Math.floor(paintedWidth);
                    height = Math.floor(paintedHeight);
                }
            }

            AnimatedLayer {
                id:              cloudsLayer
                anchors.fill:    parent
                z:               1
                movementEnabled: true
                movementPaused:  gamePage.gamePaused
                movementSpeed:   1
                imageSource:     "qrc:/resources/images/game/layer_clouds.png"
            }

            AnimatedLayer {
                id:              bushLayer
                anchors.fill:    parent
                z:               2
                movementEnabled: true
                movementPaused:  gamePage.gamePaused
                movementSpeed:   2
                imageSource:     "qrc:/resources/images/game/layer_bush.png"
            }

            AnimatedLayer {
                id:              grassLayer
                anchors.fill:    parent
                z:               3
                movementEnabled: true
                movementPaused:  gamePage.gamePaused
                movementSpeed:   4
                imageSource:     "qrc:/resources/images/game/layer_grass.png"
            }

            AnimatedLayer {
                id:              groundLayer
                anchors.fill:    parent
                z:               4
                movementEnabled: true
                movementPaused:  gamePage.gamePaused
                movementSpeed:   8
                imageSource:     "qrc:/resources/images/game/layer_ground.png"
            }

            AnimatedRopeLayer {
                id:                    ropeLayer
                anchors.fill:          parent
                z:                     5
                movementEnabled:       true
                movementPaused:        gamePage.gamePaused
                movementSpeed:         8
                suspensionHeight:      1200
                suspendedObjectsCount: 3
                imageSource:           "qrc:/resources/images/game/layer_rope.png"
            }

            Cat {
                id:                       cat
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom:           parent.bottom
                anchors.bottomMargin:     115 * imageScale
                z:                        6
                stretchTo:                512
                imageScale:               backgroundImage.imageScale
                intersectionShare:        0.25

                onCatEnlarged: {
                    ropeLayer.checkCatIntersections(cat);
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                cat.enlargeCat();
            }
        }
    }
}
