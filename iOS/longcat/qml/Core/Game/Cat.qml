import QtQuick 2.9

Column {
    id: cat

    property int stretchTo:   0

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

            NumberAnimation {
                target:   middleImage
                property: "height"
                from:     middleImage.sourceSize.height * cat.imageScale
                to:       cat.stretchTo * cat.imageScale
                duration: 250
            }

            NumberAnimation {
                target:   middleImage
                property: "height"
                from:     cat.stretchTo * cat.imageScale
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
