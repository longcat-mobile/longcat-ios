import QtQuick 2.9

Rectangle {
    id:    animatedLayer
    color: "transparent"

    property bool running:       false
    property bool paused:        false

    property real speed:         0.0
    property real imageWidth:    Math.min(leftImage.width,  rightImage.width)
    property real imageHeight:   Math.min(leftImage.height, rightImage.height)

    property string imageSource: ""

    Image {
        id:       leftImage
        x:        0 - animatedLayer.imageWidth
        y:        0
        width:    parent.width
        height:   parent.height
        source:   imageSource
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id:       rightImage
        x:        0
        y:        0
        width:    parent.width
        height:   parent.height
        source:   imageSource
        fillMode: Image.PreserveAspectCrop
        mirror:   true
    }

    SequentialAnimation {
        id:      movementAnimation
        loops:   Animation.Infinite
        running: animatedLayer.running
        paused:  animatedLayer.paused

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0 - animatedLayer.imageWidth
                to:       0
                duration: animatedLayer.speed > 0.0 ? animatedLayer.imageWidth / animatedLayer.speed * 1000 : 0
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0
                to:       animatedLayer.imageWidth
                duration: animatedLayer.speed > 0.0 ? animatedLayer.imageWidth / animatedLayer.speed * 1000 : 0
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0
                to:       animatedLayer.imageWidth
                duration: animatedLayer.speed > 0.0 ? animatedLayer.imageWidth / animatedLayer.speed * 1000 : 0
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0 - animatedLayer.imageWidth
                to:       0
                duration: animatedLayer.speed > 0.0 ? animatedLayer.imageWidth / animatedLayer.speed * 1000 : 0
            }
        }
    }
}
