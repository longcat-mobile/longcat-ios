import QtQuick 2.9

Rectangle {
    id:    animatedLayer
    color: "transparent"

    property bool movementEnabled: false
    property bool movementPaused:  false

    property int movementSpeed:    0

    property real imageWidth:      0.0
    property real imageHeight:     0.0

    property string imageSource:   ""

    onMovementEnabledChanged: {
        if (movementEnabled) {
            if (leftImage.geometrySettled && rightImage.geometrySettled) {
                movementAnimation.start();
            }
        } else {
            movementAnimation.stop();
        }
    }

    onMovementPausedChanged: {
        if (movementAnimation.running) {
            if (movementPaused) {
                movementAnimation.pause();
            } else {
                movementAnimation.resume();
            }
        }
    }

    function adjustImagePositions() {
        movementAnimation.stop();

        if (leftImage.geometrySettled && rightImage.geometrySettled) {
            imageWidth  = Math.min(leftImage.width,  rightImage.width);
            imageHeight = Math.min(leftImage.height, rightImage.height);

            rightImage.x = (width - imageWidth)  / 2;
            leftImage.x  = rightImage.x - imageWidth;

            rightImage.y = (height - imageHeight) / 2;
            leftImage.y  = (height - imageHeight) / 2;

            if (movementEnabled) {
                movementAnimation.start();
            }
        }
    }

    Image {
        id:       leftImage
        x:        0
        y:        0
        width:    parent.width
        height:   parent.height
        source:   imageSource
        fillMode: Image.PreserveAspectCrop

        property bool geometrySettled: false

        onPaintedWidthChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = Math.floor(paintedWidth);
                height = Math.floor(paintedHeight);

                animatedLayer.adjustImagePositions();
            }
        }

        onPaintedHeightChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = Math.floor(paintedWidth);
                height = Math.floor(paintedHeight);

                animatedLayer.adjustImagePositions();
            }
        }
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

        property bool geometrySettled: false

        onPaintedWidthChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = Math.floor(paintedWidth);
                height = Math.floor(paintedHeight);

                animatedLayer.adjustImagePositions();
            }
        }

        onPaintedHeightChanged: {
            if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                geometrySettled = true;

                width  = Math.floor(paintedWidth);
                height = Math.floor(paintedHeight);

                animatedLayer.adjustImagePositions();
            }
        }
    }

    SequentialAnimation {
        id: movementAnimation

        onRunningChanged: {
            if (running) {
                if (animatedLayer.movementPaused) {
                    pause();
                } else {
                    resume();
                }
            }
        }

        onStopped: {
            if (animatedLayer.movementEnabled) {
                start();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     (animatedLayer.width - animatedLayer.imageWidth) / 2 - animatedLayer.imageWidth
                to:       (animatedLayer.width - animatedLayer.imageWidth) / 2
                duration: animatedLayer.imageWidth / animatedLayer.movementSpeed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     (animatedLayer.width - animatedLayer.imageWidth) / 2
                to:       (animatedLayer.width - animatedLayer.imageWidth) / 2 + animatedLayer.imageWidth
                duration: animatedLayer.imageWidth / animatedLayer.movementSpeed * 100
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     (animatedLayer.width - animatedLayer.imageWidth) / 2
                to:       (animatedLayer.width - animatedLayer.imageWidth) / 2 + animatedLayer.imageWidth
                duration: animatedLayer.imageWidth / animatedLayer.movementSpeed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     (animatedLayer.width - animatedLayer.imageWidth) / 2 - animatedLayer.imageWidth
                to:       (animatedLayer.width - animatedLayer.imageWidth) / 2
                duration: animatedLayer.imageWidth / animatedLayer.movementSpeed * 100
            }
        }
    }
}
