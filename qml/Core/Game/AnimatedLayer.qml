import QtQuick 2.12

Rectangle {
    id:    animatedLayer
    color: "transparent"

    readonly property real imageWidth:  Math.min(leftImage.width,  rightImage.width)
    readonly property real imageHeight: Math.min(leftImage.height, rightImage.height)

    property bool running:              false
    property bool paused:               false

    property real speed:                0.0

    property url imageSource:           ""

    onImageWidthChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                movementAnimationRestartTimer.start();
            }
        }
    }

    onImageHeightChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                movementAnimationRestartTimer.start();
            }
        }
    }

    onRunningChanged: {
        if (running) {
            if (imageWidth > 0 && imageHeight > 0) {
                movementAnimationStartTimer.start();
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

        onFinished: {
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

    Timer {
        id:       movementAnimationStartTimer
        interval: 0

        onTriggered: {
            movementAnimation.start();
        }
    }

    Timer {
        id:       movementAnimationRestartTimer
        interval: 0

        onTriggered: {
            movementAnimation.restart();
        }
    }
}
