import QtQuick 2.9

Column {
    id:      object
    spacing: (0 - 16) * imageScale

    property bool consumed:        false

    property int energy:           0

    property real imageScale:      1.0

    property string consumedSound: ""

    signal playSound(string sound)

    function consume() {
        consumed = true;

        if (objectImage.consumedSource !== "") {
            objectImage.source = objectImage.consumedSource;
        }

        objectConsumeAnimation.start();

        playSound(consumedSound);
    }

    Image {
        id:       birdImage
        width:    sourceSize.width  * imageScale
        height:   sourceSize.height * imageScale
        z:        1
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id:       objectImage
        width:    sourceSize.width  * imageScale
        height:   sourceSize.height * imageScale
        fillMode: Image.PreserveAspectFit

        property string consumedSource: ""

        NumberAnimation {
            id:          objectConsumeAnimation
            target:      objectImage
            property:    "opacity"
            from:        1.0
            to:          0.0
            duration:    500
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: {
        var random_number = Math.random();

        if (random_number < 0.16) {
            birdImage.source = "qrc:/resources/images/game/birds/eagle.png";
        } else if (random_number < 0.34) {
            birdImage.source = "qrc:/resources/images/game/birds/eagle.png";
            birdImage.mirror = true;
        } else if (random_number < 0.50) {
            birdImage.source = "qrc:/resources/images/game/birds/hawk.png";
        } else if (random_number < 0.68) {
            birdImage.source = "qrc:/resources/images/game/birds/hawk.png";
            birdImage.mirror = true;
        } else if (random_number < 0.84) {
            birdImage.source = "qrc:/resources/images/game/birds/raven.png";
        } else {
            birdImage.source = "qrc:/resources/images/game/birds/raven.png";
            birdImage.mirror = true;
        }

        random_number = Math.random();

        if (random_number < 0.08) {
            energy        = 5;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/apple.png";
        } else if (random_number < 0.16) {
            energy        = 5;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/banana.png";
        } else if (random_number < 0.25) {
            energy        = -25;
            consumedSound = "BOMB";

            objectImage.source         = "qrc:/resources/images/game/objects/bomb.png";
            objectImage.consumedSource = "qrc:/resources/images/game/objects/bomb_consumed.png";
        } else if (random_number < 0.33) {
            energy        = 5;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/cherry.png";
        } else if (random_number < 0.41) {
            energy        = 10;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/chicken.png";
        } else if (random_number < 0.50) {
            energy        = 10;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/fish.png";
        } else if (random_number < 0.58) {
            energy        = 5;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/icecream.png";
        } else if (random_number < 0.66) {
            energy        = 15;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/meat.png";
        } else if (random_number < 0.75) {
            energy        = 10;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/milk.png";
        } else if (random_number < 0.83) {
            energy        = -20;
            consumedSound = "MUSHROOM";

            objectImage.source         = "qrc:/resources/images/game/objects/mushroom.png";
            objectImage.consumedSource = "qrc:/resources/images/game/objects/mushroom_consumed.png";
        } else if (random_number < 0.92) {
            energy        = 10;
            consumedSound = "GENERIC";

            objectImage.source = "qrc:/resources/images/game/objects/pizza.png";
        } else {
            energy        = -30;
            consumedSound = "SKULL";

            objectImage.source = "qrc:/resources/images/game/objects/skull.png";
        }
    }
}
