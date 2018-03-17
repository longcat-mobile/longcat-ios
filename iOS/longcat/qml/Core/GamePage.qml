import QtQuick 2.9

import "Game"

Item {
    id: gamePage

    property bool appInForeground:    Qt.application.active
    property bool pageActive:         false
    property bool interstitialActive: AdMobHelper.interstitialActive
    property bool gameRunning:        true
    property bool gameEnded:          false
    property bool gamePaused:         !appInForeground || !pageActive || interstitialActive || gameEnded

    property int bannerViewHeight:    AdMobHelper.bannerViewHeight
    property int gameDifficulty:      1
    property int maxGameDifficulty:   10
    property int gameElapsedTime:     0
    property int gameScore:           0

    onGameElapsedTimeChanged: {
        var hrs = Math.floor(gameElapsedTime / 3600);
        var mns = Math.floor((gameElapsedTime - hrs * 3600) / 60);
        var scs = Math.floor(gameElapsedTime - hrs * 3600 - mns * 60);

        if (hrs < 10) {
            hrs = "0" + hrs;
        }
        if (mns < 10) {
            mns = "0" + mns;
        }
        if (scs < 10) {
            scs = "0" + scs;
        }

        timerText.text = "%1:%2:%3".arg(hrs).arg(mns).arg(scs);
    }

    onGameScoreChanged: {
        var score = gameScore + "";

        while (score.length < 6) {
            score = "0" + score;
        }

        scoreText.text = score;
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
                id:           cloudsLayer
                anchors.fill: parent
                z:            1
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        1 * (1.0 + gamePage.gameDifficulty / 5.0)
                imageSource:  "qrc:/resources/images/game/layer_clouds.png"
            }

            AnimatedLayer {
                id:           bushLayer
                anchors.fill: parent
                z:            2
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        2 * (1.0 + gamePage.gameDifficulty / 5.0)
                imageSource:  "qrc:/resources/images/game/layer_bush.png"
            }

            AnimatedLayer {
                id:           grassLayer
                anchors.fill: parent
                z:            3
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        4 * (1.0 + gamePage.gameDifficulty / 5.0)
                imageSource:  "qrc:/resources/images/game/layer_grass.png"
            }

            AnimatedLayer {
                id:           groundLayer
                anchors.fill: parent
                z:            4
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        8 * (1.0 + gamePage.gameDifficulty / 5.0)
                imageSource:  "qrc:/resources/images/game/layer_ground.png"
            }

            AnimatedRopeLayer {
                id:                    ropeLayer
                anchors.fill:          parent
                z:                     5
                running:               gamePage.gameRunning
                paused:                gamePage.gamePaused
                speed:                 8 * (1.0 + gamePage.gameDifficulty / 5.0)
                suspensionHeight:      1200
                suspendedObjectsCount: 5 + (gamePage.gameDifficulty / 2)
                imageSource:           "qrc:/resources/images/game/layer_rope.png"
            }

            Cat {
                id:                       cat
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom:           parent.bottom
                anchors.bottomMargin:     115 * imageScale
                z:                        6
                stretchTo:                512
                energy:                   100
                maxEnergy:                100
                imageScale:               backgroundImage.imageScale
                intersectionShare:        0.25

                onAliveChanged: {
                    if (!alive) {
                        gamePage.gameEnded = true;
                    }
                }

                onCatEnlarged: {
                    ropeLayer.checkCatIntersections(cat);
                }

                onCatConsumedObject: {
                    if (object_energy > 0) {
                        gamePage.gameScore = gamePage.gameScore + object_energy;
                    }
                }
            }
        }

        Text {
            id:                  timerText
            anchors.top:         parent.top
            anchors.left:        parent.left
            anchors.topMargin:   Math.max(gamePage.bannerViewHeight + 8, 34)
            z:                   10
            text:                "00:00:00"
            color:               "yellow"
            horizontalAlignment: Text.AlignRight
            verticalAlignment:   Text.AlignVCenter
            font.family:         "Courier"
            font.pointSize:      24
        }

        Text {
            id:                  scoreText
            anchors.top:         parent.top
            anchors.right:       parent.right
            anchors.topMargin:   Math.max(gamePage.bannerViewHeight + 8, 34)
            z:                   10
            text:                "000000"
            color:               "yellow"
            horizontalAlignment: Text.AlignRight
            verticalAlignment:   Text.AlignVCenter
            font.family:         "Courier"
            font.pointSize:      24
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

        Image {
            anchors.right:        parent.right
            anchors.bottom:       parent.bottom
            anchors.rightMargin:  8
            anchors.bottomMargin: 16
            width:                sourceSize.width  * backgroundImage.imageScale
            height:               sourceSize.height * backgroundImage.imageScale
            z:                    20
            source:               "qrc:/resources/images/game/button_restart.png"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    gamePage.gameRunning     = false;
                    gamePage.gameEnded       = false;
                    gamePage.gameDifficulty  = 1;
                    gamePage.gameElapsedTime = 0;
                    gamePage.gameScore       = 0;

                    cat.alive  = true;
                    cat.energy = cat.maxEnergy;

                    gamePage.gameRunning = true;

                    AdMobHelper.showInterstitial();
                }
            }
        }
    }

    Timer {
        id:       gameTimer
        running:  !gamePage.gamePaused
        interval: 1000
        repeat:   true

        onTriggered: {
            gamePage.gameElapsedTime = gamePage.gameElapsedTime + 1;

            cat.energy = cat.energy - 5;

            gamePage.gameDifficulty = Math.min(gamePage.gameElapsedTime / 5, gamePage.maxGameDifficulty);
        }
    }
}
