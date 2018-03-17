import QtQuick 2.9

Image {
    id:       suspendedObject
    fillMode: Image.PreserveAspectFit

    property real imageScale:   1.0

    property string objectType: ""

    Component.onCompleted: {
        if (Math.random() < 0.5) {
            objectType = "GOOD";
            source     = "qrc:/resources/images/game/object_good_0.png";
        } else {
            objectType = "BAD";
            source     = "qrc:/resources/images/game/object_bad_0.png";
        }

        width  = sourceSize.width  * imageScale;
        height = sourceSize.height * imageScale;
    }
}
