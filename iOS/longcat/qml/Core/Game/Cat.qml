import QtQuick 2.9

Column {
    id: cat

    property int stretchTo:          0

    property real imageScale:        1.0
    property real intersectionShare: 1.0

    signal catEnlarged();

    function enlargeCat() {
        enlargeCatAnimation.start();
    }

    function checkIntersection(object) {
        var cat_rect    = Qt.rect((width - width * intersectionShare) / 2, 0, width * intersectionShare, height);
        var object_rect = mapFromItem(object, 0, 0, object.width, object.height);

        if (!(cat_rect.x + cat_rect.width  < object_rect.x || object_rect.x + object_rect.width  < cat_rect.x ||
              cat_rect.y + cat_rect.height < object_rect.y || object_rect.y + object_rect.height < cat_rect.y)) {
            if (object.objectType === "BAD") {
                catDamagedAnimation.start();
            }
        }
    }

    Image {
        id:       topImage
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

            ScriptAction {
                script: {
                    cat.catEnlarged();
                }
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
        id:       bottomImage
        width:    sourceSize.width  * cat.imageScale
        height:   sourceSize.height * cat.imageScale
        source:   "qrc:/resources/images/game/cat_bottom.png"
        fillMode: Image.PreserveAspectFit
    }

    SequentialAnimation {
        id:    catDamagedAnimation
        loops: 3

        NumberAnimation {
            targets:  [topImage, middleImage, bottomImage]
            property: "opacity"
            from:     1.0
            to:       0.0
            duration: 75
        }

        NumberAnimation {
            targets:  [topImage, middleImage, bottomImage]
            property: "opacity"
            from:     0.0
            to:       1.0
            duration: 75
        }
    }
}
