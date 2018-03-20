import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.9

Item {
    id: mainPage

    property bool appInForeground: Qt.application.active
    property bool pageActive:      false

    SoundEffect {
        id:     musicSoundEffect
        volume: 0.5
        muted:  !mainPage.appInForeground || !mainPage.pageActive
        loops:  SoundEffect.Infinite
        source: "qrc:/resources/sound/main/music.wav"

        Component.onCompleted: {
            play();
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
            anchors.bottomMargin:     32 * backgroundImage.imageScale
            z:                        10
            width:                    sourceSize.width  * backgroundImage.imageScale
            height:                   sourceSize.height * backgroundImage.imageScale
            source:                   allowed ? "qrc:/resources/images/main/button_leaderboard.png" :
                                                "qrc:/resources/images/main/button_leaderboard_disabled.png"

            property bool allowed: GameCenterHelper.gameCenterEnabled

            MouseArea {
                anchors.fill: parent
                enabled:      parent.allowed

                onClicked: {
                    GameCenterHelper.showLeaderboard();
                }
            }
        }
    }

    Component.onCompleted: {
        GameCenterHelper.initialize();
    }
}
