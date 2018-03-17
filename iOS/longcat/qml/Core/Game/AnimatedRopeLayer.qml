import QtQuick 2.9

Rectangle {
    id:    animatedRopeLayer
    color: "transparent"

    property bool running:              false
    property bool paused:               false

    property int speed:                 0
    property int suspensionHeight:      0
    property int suspendedObjectsCount: 0

    property real imageWidth:           Math.min(leftImage.width,  rightImage.width)
    property real imageHeight:          Math.min(leftImage.height, rightImage.height)

    property string imageSource:        ""

    onRunningChanged: {
        if (running) {
            if (imageWidth > 0 && imageHeight > 0) {
                leftImage.placeSuspendedObjects();

                movementAnimation.start();
            }
        } else {
            movementAnimation.stop();

            leftImage.clearSuspendedObjects();
            rightImage.clearSuspendedObjects();
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
                leftImage.placeSuspendedObjects();

                movementAnimation.restart();
            }
        }
    }

    onImageHeightChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                leftImage.placeSuspendedObjects();

                movementAnimation.restart();
            }
        }
    }

    function checkCatIntersections(cat) {
        for (var i = 0; i < leftImage.children.length; i++) {
            cat.checkIntersection(leftImage.children[i]);
        }

        for (var j = 0; j < rightImage.children.length; j++) {
            cat.checkIntersection(rightImage.children[j]);
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

        property real imageScale: sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

        function placeSuspendedObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }

            var component = Qt.createComponent("SuspendedObject.qml");

            if (component.status === Component.Ready) {
                for (var j = 0; j < animatedRopeLayer.suspendedObjectsCount; j++) {
                    if (Math.random() > 0.25) {
                        var suspended_object = component.createObject(leftImage, {imageScale: imageScale});

                        suspended_object.x = (width / animatedRopeLayer.suspendedObjectsCount) * j;
                        suspended_object.y = animatedRopeLayer.suspensionHeight * imageScale;
                    }
                }
            } else {
                console.log(component.errorString());
            }
        }

        function clearSuspendedObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
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

        property real imageScale: sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

        function placeSuspendedObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }

            var component = Qt.createComponent("SuspendedObject.qml");

            if (component.status === Component.Ready) {
                for (var j = 0; j < animatedRopeLayer.suspendedObjectsCount; j++) {
                    if (Math.random() > 0.25) {
                        var suspended_object = component.createObject(rightImage, {imageScale: imageScale});

                        suspended_object.x = (width / animatedRopeLayer.suspendedObjectsCount) * j;
                        suspended_object.y = animatedRopeLayer.suspensionHeight * imageScale;
                    }
                }
            } else {
                console.log(component.errorString());
            }
        }

        function clearSuspendedObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }
        }
    }

    SequentialAnimation {
        id: movementAnimation

        onRunningChanged: {
            if (running) {
                if (animatedRopeLayer.paused) {
                    pause();
                } else {
                    resume();
                }
            }
        }

        onStopped: {
            if (animatedRopeLayer.running) {
                start();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2 - animatedRopeLayer.imageWidth
                to:       (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2
                duration: animatedRopeLayer.imageWidth / animatedRopeLayer.speed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2
                to:       (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2 + animatedRopeLayer.imageWidth
                duration: animatedRopeLayer.imageWidth / animatedRopeLayer.speed * 100
            }
        }

        ScriptAction {
            script: {
                rightImage.placeSuspendedObjects();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2
                to:       (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2 + animatedRopeLayer.imageWidth
                duration: animatedRopeLayer.imageWidth / animatedRopeLayer.speed * 100
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2 - animatedRopeLayer.imageWidth
                to:       (animatedRopeLayer.width - animatedRopeLayer.imageWidth) / 2
                duration: animatedRopeLayer.imageWidth / animatedRopeLayer.speed * 100
            }
        }

        ScriptAction {
            script: {
                leftImage.placeSuspendedObjects();
            }
        }
    }
}
