import QtQuick 2.9

Rectangle {
    id:    animatedLayer
    color: "transparent"

    property bool running:       false
    property bool paused:        false

    property int speed:          0

    property real imageWidth:    Math.min(leftImage.width,  rightImage.width)
    property real imageHeight:   Math.min(leftImage.height, rightImage.height)

    property string imageSource: ""

    onRunningChanged: {
        if (running) {
            if (imageWidth > 0 && imageHeight > 0) {
                movementAnimation.start();
            }
        } else {
            movementAnimation.stop();
        }
    }

    onPausedChanged: {
        if (movementAnimation.running) {
            if (paused) {
                movementAnimation.pause();
            } else {
                movementAnimation.resume();
            }
        }
    }

    onImageWidthChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                movementAnimation.restart();
            }
        }
    }

    onImageHeightChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                movementAnimation.restart();
            }
        }
    }

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
        id: movementAnimation

        onRunningChanged: {
            if (running) {
                if (animatedLayer.paused) {
                    pause();
                } else {
                    resume();
                }
            }
        }

        onStopped: {
            if (animatedLayer.running) {
                start();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0 - animatedLayer.imageWidth
                to:       0
                duration: animatedLayer.imageWidth / animatedLayer.speed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0
                to:       animatedLayer.imageWidth
                duration: animatedLayer.imageWidth / animatedLayer.speed * 100
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0
                to:       animatedLayer.imageWidth
                duration: animatedLayer.imageWidth / animatedLayer.speed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0 - animatedLayer.imageWidth
                to:       0
                duration: animatedLayer.imageWidth / animatedLayer.speed * 100
            }
        }
    }
}
