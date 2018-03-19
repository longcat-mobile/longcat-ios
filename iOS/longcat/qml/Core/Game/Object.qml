import QtQuick 2.9

Image {
    id:       object
    fillMode: Image.PreserveAspectFit

    property bool consumed:         false

    property int energy:            0

    property real imageScale:       1.0

    property string consumedSource: ""
    property string consumedSound:  ""

    signal playSound(string sound)

    function consume() {
        consumed = true;

        if (consumedSource !== "") {
            source = consumedSource;
        }

        consumeAnimation.start();

        playSound(consumedSound);
    }

    NumberAnimation {
        id:          consumeAnimation
        target:      object
        property:    "opacity"
        from:        1.0
        to:          0.0
        duration:    500
        easing.type: Easing.OutCubic
    }

    Component.onCompleted: {
        var random_number = Math.random();

        if (random_number < 0.08) {
            energy         = 5;
            source         = "qrc:/resources/images/game/objects/apple.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.16) {
            energy         = 5;
            source         = "qrc:/resources/images/game/objects/banana.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.25) {
            energy         = -25;
            source         = "qrc:/resources/images/game/objects/bomb.png";
            consumedSource = "qrc:/resources/images/game/objects/bomb_consumed.png";
            consumedSound  = "BOMB";
        } else if (random_number < 0.33) {
            energy         = 5;
            source         = "qrc:/resources/images/game/objects/cherry.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.41) {
            energy         = 10;
            source         = "qrc:/resources/images/game/objects/chicken.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.50) {
            energy         = 10;
            source         = "qrc:/resources/images/game/objects/fish.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.58) {
            energy         = 5;
            source         = "qrc:/resources/images/game/objects/icecream.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.66) {
            energy         = 15;
            source         = "qrc:/resources/images/game/objects/meat.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.75) {
            energy         = 10;
            source         = "qrc:/resources/images/game/objects/milk.png";
            consumedSound  = "GENERIC";
        } else if (random_number < 0.83) {
            energy         = -20;
            source         = "qrc:/resources/images/game/objects/mushroom.png";
            consumedSource = "qrc:/resources/images/game/objects/mushroom_consumed.png";
            consumedSound  = "MUSHROOM";
        } else if (random_number < 0.92) {
            energy         = 10;
            source         = "qrc:/resources/images/game/objects/pizza.png";
            consumedSound  = "GENERIC";
        } else {
            energy         = -30;
            source         = "qrc:/resources/images/game/objects/skull.png";
            consumedSound  = "SKULL";
        }

        width  = sourceSize.width  * imageScale;
        height = sourceSize.height * imageScale;
    }
}
