import QtQuick 2.9

Column {
    id: cat

    property real imageScale: 1.0

    function enlargeCat() {
        enlargeCatAnimation.start();
    }

    Image {
        width:    sourceSize.width  * cat.imageScale
        height:   sourceSize.height * cat.imageScale
        source:   "qrc:/resources/images/game/cat_top.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id:       middleImage
        width:    sourceSize.width  * cat.imageScale
        height:   sourceSize.height * cat.imageScale
        source:   "qrc:/resources/images/game/cat_middle.png"
        fillMode: Image.Stretch

        SequentialAnimation {
            id: enlargeCatAnimation

            PropertyAnimation {
                target:   middleImage
                property: "height"
                from:     middleImage.sourceSize.height * cat.imageScale
                to:       512 * cat.imageScale
                duration: 250
            }

            PropertyAnimation {
                target:   middleImage
                property: "height"
                from:     512 * cat.imageScale
                to:       middleImage.sourceSize.height * cat.imageScale
                duration: 250
            }
        }
    }

    Image {
        width:    sourceSize.width  * cat.imageScale
        height:   sourceSize.height * cat.imageScale
        source:   "qrc:/resources/images/game/cat_bottom.png"
        fillMode: Image.PreserveAspectFit
    }
}
