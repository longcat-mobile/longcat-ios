import QtQuick 2.12
import QtQuick.Controls 2.5
import QtMultimedia 5.12

Item {
    id: mainPage

    property bool appInForeground: Qt.application.state === Qt.ApplicationActive
    property bool pageActive:      StackView.status === StackView.Active

    SoundEffect {
        id:     musicSoundEffect
        volume: 0.5
        loops:  SoundEffect.Infinite
        source: "qrc:/resources/sound/main/music.wav"

        property bool playbackEnabled: mainPage.appInForeground && mainPage.pageActive

        onPlaybackEnabledChanged: {
            if (playbackEnabled) {
                play();
            } else {
                stop();
            }
        }
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
            source:           "qrc:/resources/images/main/background.png"
            fillMode:         Image.PreserveAspectCrop

            property real imageScale: sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0
        }

        Image {
            anchors.centerIn: parent
            z:                10
            width:            sourceSize.width  * backgroundImage.imageScale
            height:           sourceSize.height * backgroundImage.imageScale
            source:           "qrc:/resources/images/main/button_play.png"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    var component = Qt.createComponent("GamePage.qml");

                    if (component.status === Component.Ready) {
                        mainStackView.push(component, StackView.Immediate);
                    } else {
                        console.log(component.errorString());
                    }
                }
            }
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     16 * backgroundImage.imageScale
            z:                        10
            width:                    sourceSize.width  * backgroundImage.imageScale
            height:                   sourceSize.height * backgroundImage.imageScale
            source:                   enabled ? "qrc:/resources/images/main/button_leaderboard.png" :
                                                "qrc:/resources/images/main/button_leaderboard_disabled.png"
            enabled:                  GameCenterHelper.gameCenterEnabled

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    GameCenterHelper.showLeaderboard();
                }
            }
        }
    }

    Component.onCompleted: {
        GameCenterHelper.authenticate();
    }
}
