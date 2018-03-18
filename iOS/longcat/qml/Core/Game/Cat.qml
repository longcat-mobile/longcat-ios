import QtQuick 2.9

Column {
    id: cat

    property bool alive:             true

    property int stretchTo:          0
    property int energy:             0
    property int maxEnergy:          0

    property real imageScale:        1.0
    property real intersectionShare: 1.0

    signal catEnlarged()
    signal catConsumedObject(int object_energy)

    onEnergyChanged: {
        energy = Math.max(0, Math.min(energy, maxEnergy));

        if (energy <= 0) {
            alive = false;

            catDeadAnimation.start();
        }
    }

    function enlargeCat() {
        if (alive) {
            enlargeCatAnimation.start();
        }
    }

    function reviveCat() {
        catDeadAnimation.stop();

        opacity = 1.0;
        visible = true;

        energy = maxEnergy;
        alive  = true;
    }

    function checkIntersection(object) {
        if (alive) {
            var cat_rect    = Qt.rect((width - width * intersectionShare) / 2, 0, width * intersectionShare, height);
            var object_rect = mapFromItem(object, 0, 0, object.width, object.height);

            if (!object.consumed) {
                if (!(cat_rect.x + cat_rect.width  < object_rect.x || object_rect.x + object_rect.width  < cat_rect.x ||
                      cat_rect.y + cat_rect.height < object_rect.y || object_rect.y + object_rect.height < cat_rect.y)) {
                    object.consume();

                    energy = energy + object.energy;

                    if (alive && object.energy < 0) {
                        catDamagedAnimation.start();
                    }

                    catConsumedObject(object.energy);
                }
            }
        }
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
        width:    sourceSize.width  * cat.imageScale
        height:   sourceSize.height * cat.imageScale
        source:   "qrc:/resources/images/game/cat_bottom.png"
        fillMode: Image.PreserveAspectFit
    }

    SequentialAnimation {
        id:    catDamagedAnimation
        loops: 3

        NumberAnimation {
            target:   cat
            property: "opacity"
            from:     1.0
            to:       0.0
            duration: 75
        }

        NumberAnimation {
            target:   cat
            property: "opacity"
            from:     0.0
            to:       1.0
            duration: 75
        }
    }

    SequentialAnimation {
        id: catDeadAnimation

        SequentialAnimation {
            loops: 5

            NumberAnimation {
                target:   cat
                property: "opacity"
                from:     1.0
                to:       0.0
                duration: 75
            }

            NumberAnimation {
                target:   cat
                property: "opacity"
                from:     0.0
                to:       1.0
                duration: 75
            }
        }

        SequentialAnimation {
            NumberAnimation {
                target:   cat
                property: "opacity"
                from:     1.0
                to:       0.0
                duration: 75
            }
        }

        ScriptAction {
            script: {
                cat.visible = false;
                cat.opacity = 1.0;
            }
        }
    }
}