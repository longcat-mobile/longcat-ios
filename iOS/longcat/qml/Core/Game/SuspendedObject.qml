import QtQuick 2.9

Image {
    id:       suspendedObject
    fillMode: Image.PreserveAspectFit

    property int energy:      0

    property real imageScale: 1.0

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
