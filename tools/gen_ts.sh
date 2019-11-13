#!/bin/sh

PATH=$PATH:~/Qt/5.13.0/ios/bin

lupdate -locations absolute ../longcat.pro -ts ../translations/longcat_ja.src.ts
lupdate -locations absolute ../qml         -ts ../translations/longcat_ja.qml.ts

lupdate -locations absolute ../longcat.pro -ts ../translations/longcat_ru.src.ts
lupdate -locations absolute ../qml         -ts ../translations/longcat_ru.qml.ts

lconvert ../translations/longcat_ja.src.ts ../translations/longcat_ja.qml.ts -o ../translations/longcat_ja.ts
lconvert ../translations/longcat_ru.src.ts ../translations/longcat_ru.qml.ts -o ../translations/longcat_ru.ts
