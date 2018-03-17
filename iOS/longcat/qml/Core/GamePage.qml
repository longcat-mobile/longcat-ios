import QtQuick 2.9

import "Game"

Item {
    id: gamePage

    property bool appInForeground: Qt.application.active
    property bool pageActive:      false
    property bool gamePaused:      !appInForeground || !pageActive

    property int bannerViewHeight: AdMobHelper.bannerViewHeight

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
                energy:                   10
                maxEnergy:                100
                imageScale:               backgroundImage.imageScale
                intersectionShare:        0.25

                onCatEnlarged: {
                    ropeLayer.checkCatIntersections(cat);
                }
            }
        }

        Rectangle {
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            width:                  parent.width  / 10
            height:                 parent.height / 3
            z:                      10
            radius:                 8
            border.width:           4
            border.color:           "black"

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color:    "green"
                }

                GradientStop {
                    position: 0.5
                    color:    "yellow"
                }

                GradientStop {
                    position: 1.0
                    color:    "red"
                }
            }

            Rectangle {
                anchors.left:    parent.left
                anchors.right:   parent.right
                anchors.top:     parent.top
                anchors.margins: parent.border.width
                height:          cat.maxEnergy > 0 ? (parent.height - parent.border.width * 2) *
                                                     (1.0 - cat.energy / cat.maxEnergy) :
                                                     parent.height - parent.border.width * 2
                color:           "lightgray"
            }
        }

        MouseArea {
            anchors.fill: parent
            z:            15

            onClicked: {
                cat.enlargeCat();
            }
        }
    }
}
