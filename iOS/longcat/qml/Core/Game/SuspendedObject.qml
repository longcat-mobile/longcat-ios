import QtQuick 2.9

Image {
    id:       suspendedObject
    fillMode: Image.PreserveAspectFit

    property bool consumed:   false

    property int energy:      0

    property real imageScale: 1.0

    function consume() {
        consumed = true;

        consumeAnimation.start();
    }

    NumberAnimation {
        id:          consumeAnimation
        target:      suspendedObject
        property:    "opacity"
        from:        1.0
        to:          0.0
        duration:    500
        easing.type: Easing.OutCubic
    }

    Component.onCompleted: {
        if (Math.random() < 0.5) {
            energy = 10;
            source = "qrc:/resources/images/game/object_good_0.png";
        } else {
            energy = -10;
            source = "qrc:/resources/images/game/object_bad_0.png";
        }

        width  = sourceSize.width  * imageScale;
        height = sourceSize.height * imageScale;
    }
}
