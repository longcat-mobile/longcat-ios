import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id: mainPage

    property bool appInForeground: Qt.application.active
    property bool pageActive:      false

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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     16
            z:                        10
            width:                    sourceSize.width  * backgroundImage.imageScale
            height:                   sourceSize.height * backgroundImage.imageScale
            source:                   "qrc:/resources/images/main/button_play.png"

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
    }
}
