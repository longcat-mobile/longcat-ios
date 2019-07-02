import QtQuick 2.12
import QtMultimedia 5.12

Rectangle {
    id:    animatedObjectsLayer
    color: "transparent"

    readonly property real imageWidth:   Math.min(leftImage.width,  rightImage.width)
    readonly property real imageHeight:  Math.min(leftImage.height, rightImage.height)

    property bool running:               false
    property bool paused:                false

    property int objectsHeight:          0
    property int objectsCount:           0

    property real speed:                 0.0
    property real edibleObjectsHandicap: 1.0

    property string imageSource:         ""

    onRunningChanged: {
        if (running) {
            if (imageWidth > 0 && imageHeight > 0) {
                leftImage.placeObjects();

                movementAnimationStartTimer.start();
            }
        } else {
            movementAnimation.stop();

            leftImage.clearObjects();
            rightImage.clearObjects();
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
                leftImage.placeObjects();

                movementAnimationRestartTimer.start();
            }
        }
    }

    onImageHeightChanged: {
        if (imageWidth > 0 && imageHeight > 0) {
            if (running) {
                leftImage.placeObjects();

                movementAnimationRestartTimer.start();
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

    function playSound(sound) {
        if (sound === "BOMB") {
            bombAudio.play();
        } else if (sound === "MUSHROOM") {
            mushroomAudio.play();
        } else if (sound === "SKULL") {
            skullAudio.play();
        } else {
            genericAudio.play();
        }
    }

    Audio {
        id:     genericAudio
        volume: 1.0
        source: "qrc:/resources/sound/game/objects/generic.wav"

        onError: {
            console.log(errorString);
        }
    }

    Audio {
        id:     bombAudio
        volume: 1.0
        source: "qrc:/resources/sound/game/objects/bomb.wav"

        onError: {
            console.log(errorString);
        }
    }

    Audio {
        id:     mushroomAudio
        volume: 1.0
        source: "qrc:/resources/sound/game/objects/mushroom.wav"

        onError: {
            console.log(errorString);
        }
    }

    Audio {
        id:     skullAudio
        volume: 1.0
        source: "qrc:/resources/sound/game/objects/skull.wav"

        onError: {
            console.log(errorString);
        }
    }

    Image {
        id:       leftImage
        x:        0 - animatedObjectsLayer.imageWidth
        y:        0
        width:    parent.width
        height:   parent.height
        source:   imageSource
        fillMode: Image.PreserveAspectCrop

        readonly property real imageScale: sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

        function placeObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }

            var component = Qt.createComponent("Object.qml");

            if (component.status === Component.Ready) {
                for (var j = 0; j < animatedObjectsLayer.objectsCount; j++) {
                    if (Math.random() > 0.25) {
                        var object = component.createObject(leftImage, {"imageScale": imageScale, "edibleHandicap": animatedObjectsLayer.edibleObjectsHandicap});

                        object.x = (width / animatedObjectsLayer.objectsCount) * j;
                        object.y = animatedObjectsLayer.objectsHeight * imageScale;

                        object.playSound.connect(animatedObjectsLayer.playSound);
                    }
                }
            } else {
                console.log(component.errorString());
            }
        }

        function clearObjects() {
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

        readonly property real imageScale: sourceSize.width > 0.0 ? paintedWidth / sourceSize.width : 1.0

        function placeObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }

            var component = Qt.createComponent("Object.qml");

            if (component.status === Component.Ready) {
                for (var j = 0; j < animatedObjectsLayer.objectsCount; j++) {
                    if (Math.random() > 0.25) {
                        var object = component.createObject(rightImage, {"imageScale": imageScale, "edibleHandicap": animatedObjectsLayer.edibleObjectsHandicap});

                        object.x = (width / animatedObjectsLayer.objectsCount) * j;
                        object.y = animatedObjectsLayer.objectsHeight * imageScale;

                        object.playSound.connect(animatedObjectsLayer.playSound);
                    }
                }
            } else {
                console.log(component.errorString());
            }
        }

        function clearObjects() {
            for (var i = children.length - 1; i >= 0; i--) {
                children[i].destroy();
            }
        }
    }

    SequentialAnimation {
        id: movementAnimation

        onRunningChanged: {
            if (running) {
                if (animatedObjectsLayer.paused) {
                    pause();
                } else {
                    resume();
                }
            }
        }

        onFinished: {
            if (animatedObjectsLayer.running) {
                start();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0 - animatedObjectsLayer.imageWidth
                to:       0
                duration: animatedObjectsLayer.speed > 0.0 ? animatedObjectsLayer.imageWidth / animatedObjectsLayer.speed * 1000 : 0
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0
                to:       animatedObjectsLayer.imageWidth
                duration: animatedObjectsLayer.speed > 0.0 ? animatedObjectsLayer.imageWidth / animatedObjectsLayer.speed * 1000 : 0
            }
        }

        ScriptAction {
            script: {
                rightImage.placeObjects();
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target:   leftImage
                property: "x"
                from:     0
                to:       animatedObjectsLayer.imageWidth
                duration: animatedObjectsLayer.speed > 0.0 ? animatedObjectsLayer.imageWidth / animatedObjectsLayer.speed * 1000 : 0
            }

            NumberAnimation {
                target:   rightImage
                property: "x"
                from:     0 - animatedObjectsLayer.imageWidth
                to:       0
                duration: animatedObjectsLayer.speed > 0.0 ? animatedObjectsLayer.imageWidth / animatedObjectsLayer.speed * 1000 : 0
            }
        }

        ScriptAction {
            script: {
                leftImage.placeObjects();
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
