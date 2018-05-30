import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.9

import "Game"

Item {
    id: gamePage

    property bool appInForeground:    Qt.application.active
    property bool pageActive:         false
    property bool interstitialActive: AdMobHelper.interstitialActive
    property bool shareViewActive:    false
    property bool gameRunning:        true
    property bool gameEnded:          false
    property bool gamePaused:         !appInForeground || !pageActive || interstitialActive || shareViewActive || gameEnded

    property int bannerViewHeight:    AdMobHelper.bannerViewHeight
    property int gameDifficulty:      0
    property int maxGameDifficulty:   10
    property int gameElapsedTime:     0
    property int gameScore:           0

    onGameRunningChanged: {
        if (gameRunning) {
            pressHintImage.visible = true;
        } else {
            pressHintImage.visible = true;
        }
    }

    onGameEndedChanged: {
        if (gameEnded) {
            pressHintImage.visible = false;
        }
    }

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

    function captureImage() {
        if (!gamePage.grabToImage(function (result) {
            result.saveToFile(ShareHelper.imageFilePath);

            shareViewActive = true;

            ShareHelper.showShareToView(ShareHelper.imageFilePath);
        })) {
            console.log("grabToImage() failed");
        }
    }

    function shareToViewCompleted() {
        shareViewActive = false;
    }

    SoundEffect {
        id:     musicSoundEffect
        volume: 0.5
        loops:  SoundEffect.Infinite
        source: "qrc:/resources/sound/game/music.wav"

        property bool playbackEnabled: !gamePage.gamePaused

        onPlaybackEnabledChanged: {
            if (playbackEnabled) {
                play();
            } else {
                stop();
            }
        }
    }

    Audio {
        id:     gameOverAudio
        volume: 1.0
        source: "qrc:/resources/sound/game/game_over.wav"

        onError: {
            console.log(errorString);
        }
    }

    FontLoader {
        id:     arcadeClassicFont
        source: "qrc:/resources/fonts/game/arcade_classic.ttf"
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:               backgroundImage
            anchors.centerIn: parent
            width:            parent.width
            height:           parent.height
            source:           "qrc:/resources/images/game/background.png"
            fillMode:         Image.PreserveAspectCrop

            property bool geometrySettled: false

            property real visibleWidth:    0.0
            property real imageScale:      sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

            onPaintedWidthChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    visibleWidth = width;

                    width  = Math.floor(paintedWidth);
                    height = Math.floor(paintedHeight);
                }
            }

            onPaintedHeightChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    visibleWidth = width;

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
                speed:        0.125 * (backgroundImage.visibleWidth / 1.0) * (0.5 + gamePage.gameDifficulty / 20.0)
                imageSource:  "qrc:/resources/images/game/layer_clouds.png"
            }

            AnimatedLayer {
                id:           hillsLayer
                anchors.fill: parent
                z:            2
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        0.25 * (backgroundImage.visibleWidth / 1.0) * (0.5 + gamePage.gameDifficulty / 20.0)
                imageSource:  "qrc:/resources/images/game/layer_hills.png"
            }

            AnimatedLayer {
                id:           forefrontLayer
                anchors.fill: parent
                z:            3
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        0.5 * (backgroundImage.visibleWidth / 1.0) * (0.5 + gamePage.gameDifficulty / 20.0)
                imageSource:  "qrc:/resources/images/game/layer_forefront.png"
            }

            AnimatedLayer {
                id:           groundLayer
                anchors.fill: parent
                z:            4
                running:      gamePage.gameRunning
                paused:       gamePage.gamePaused
                speed:        1.0 * (backgroundImage.visibleWidth / 1.0) * (0.5 + gamePage.gameDifficulty / 20.0)
                imageSource:  "qrc:/resources/images/game/layer_ground.png"
            }

            AnimatedObjectsLayer {
                id:            objectsLayer
                anchors.fill:  parent
                z:             5
                running:       gamePage.gameRunning
                paused:        gamePage.gamePaused
                objectsHeight: 172
                objectsCount:  12 + (gamePage.gameDifficulty / 2)
                speed:         1.0 * (backgroundImage.visibleWidth / 1.0) * (0.5 + gamePage.gameDifficulty / 20.0)
                imageSource:   "qrc:/resources/images/game/layer_objects.png"
            }

            Cat {
                id:                       cat
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom:           parent.bottom
                anchors.bottomMargin:     80 * imageScale
                z:                        6
                paused:                   gamePage.gamePaused
                stretchTo:                192
                energy:                   100
                maxEnergy:                100
                imageScale:               backgroundImage.imageScale
                intersectionShare:        0.25

                onAliveChanged: {
                    if (!alive) {
                        gamePage.gameEnded = true;

                        gameOverAudio.play();

                        GameCenterHelper.reportScore(gamePage.gameScore);
                    }
                }

                onCatEnlarged: {
                    objectsLayer.checkCatIntersections(cat);
                }

                onCatConsumedObject: {
                    if (object_energy > 0) {
                        gamePage.gameScore = gamePage.gameScore + object_energy;
                    }
                }

                onCatDead: {
                    catRIPAnimation.start();

                    catRIPImage.visible = true;
                }
            }

            Image {
                id:                       catRIPImage
                anchors.horizontalCenter: parent.horizontalCenter
                y:                        parent.height - height - cat.anchors.bottomMargin
                z:                        7
                width:                    sourceSize.width  * backgroundImage.imageScale
                height:                   sourceSize.height * backgroundImage.imageScale
                source:                   "qrc:/resources/images/game/cat_rip.png"
                fillMode:                 Image.Stretch
                visible:                  false

                NumberAnimation {
                    id:       catRIPAnimation
                    target:   catRIPImage
                    property: "y"
                    from:     0 - catRIPImage.height
                    to:       catRIPImage.parent.height - catRIPImage.height - cat.anchors.bottomMargin
                    duration: 250
                }
            }
        }

        Column {
            anchors.top:       parent.top
            anchors.left:      parent.left
            anchors.topMargin: Math.max(gamePage.bannerViewHeight + 4 * backgroundImage.imageScale, 34)
            z:                 10
            spacing:           4 * backgroundImage.imageScale

            Text {
                id:                  timerText
                anchors.left:        parent.left
                text:                "00:00:00"
                color:               "blue"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment:   Text.AlignVCenter
                font.family:         arcadeClassicFont.name
                font.pointSize:      32
            }

            Text {
                id:                  playerRankText
                anchors.left:        parent.left
                visible:             playerRankText.playerRank !== 0 && playerScoreText.playerScore !== 0
                text:                "#%1".arg(playerRank)
                color:               "red"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment:   Text.AlignVCenter
                font.family:         arcadeClassicFont.name
                font.pointSize:      32

                property int playerRank: GameCenterHelper.playerRank
            }
        }

        Column {
            anchors.top:       parent.top
            anchors.right:     parent.right
            anchors.topMargin: Math.max(gamePage.bannerViewHeight + 4 * backgroundImage.imageScale, 34)
            z:                 10
            spacing:           4 * backgroundImage.imageScale

            Text {
                id:                  scoreText
                anchors.right:       parent.right
                text:                "000000"
                color:               "blue"
                horizontalAlignment: Text.AlignRight
                verticalAlignment:   Text.AlignVCenter
                font.family:         arcadeClassicFont.name
                font.pointSize:      32
            }

            Text {
                id:                  playerScoreText
                anchors.right:       parent.right
                visible:             playerRankText.playerRank !== 0 && playerScoreText.playerScore !== 0
                text:                "000000"
                color:               "red"
                horizontalAlignment: Text.AlignRight
                verticalAlignment:   Text.AlignVCenter
                font.family:         arcadeClassicFont.name
                font.pointSize:      32

                property int playerScore: GameCenterHelper.playerScore

                onPlayerScoreChanged: {
                    var score = playerScore + "";

                    while (score.length < 6) {
                        score = "0" + score;
                    }

                    playerScoreText.text = score;
                }
            }
        }

        Rectangle {
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            z:                      10
            width:                  parent.width  / 10
            height:                 parent.height / 3
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

        Image {
            id:               pressHintImage
            anchors.centerIn: parent
            z:                10
            width:            sourceSize.width  * backgroundImage.imageScale
            height:           sourceSize.height * backgroundImage.imageScale
            source:           "qrc:/resources/images/game/hand.png"

            SequentialAnimation {
                loops:   Animation.Infinite
                running: pressHintImage.visible

                NumberAnimation {
                    target:   pressHintImage
                    property: "opacity"
                    from:     1.0
                    to:       0.0
                    duration: 250
                }

                NumberAnimation {
                    target:   pressHintImage
                    property: "opacity"
                    from:     0.0
                    to:       1.0
                    duration: 250
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z:            15

            onClicked: {
                pressHintImage.visible = false;

                cat.enlargeCat();
            }
        }

        Image {
            anchors.left:         parent.left
            anchors.bottom:       parent.bottom
            anchors.leftMargin:   8  * backgroundImage.imageScale
            anchors.bottomMargin: 16 * backgroundImage.imageScale
            z:                    20
            width:                sourceSize.width  * backgroundImage.imageScale
            height:               sourceSize.height * backgroundImage.imageScale
            source:               "qrc:/resources/images/game/button_back.png"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (ReachabilityHelper.internetConnected) {
                        StoreHelper.requestReview();
                    }

                    mainStackView.pop(StackView.Immediate);
                }
            }
        }

        Column {
            anchors.right:        parent.right
            anchors.bottom:       parent.bottom
            anchors.rightMargin:  8  * backgroundImage.imageScale
            anchors.bottomMargin: 16 * backgroundImage.imageScale
            z:                    20
            spacing:              16 * backgroundImage.imageScale

            Image {
                width:  sourceSize.width  * backgroundImage.imageScale
                height: sourceSize.height * backgroundImage.imageScale
                source: "qrc:/resources/images/game/button_capture.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gamePage.captureImage();
                    }
                }
            }

            Image {
                width:  sourceSize.width  * backgroundImage.imageScale
                height: sourceSize.height * backgroundImage.imageScale
                source: "qrc:/resources/images/game/button_restart.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gamePage.gameRunning     = false;
                        gamePage.gameEnded       = false;
                        gamePage.gameDifficulty  = 0;
                        gamePage.gameElapsedTime = 0;
                        gamePage.gameScore       = 0;

                        catRIPAnimation.stop();

                        catRIPImage.visible = false;

                        cat.reviveCat();

                        gamePage.gameRunning = true;

                        if (Math.random() < 0.30) {
                            AdMobHelper.showInterstitial();
                        }
                    }
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

    Component.onCompleted: {
        ShareHelper.shareToViewCompleted.connect(shareToViewCompleted);
    }
}