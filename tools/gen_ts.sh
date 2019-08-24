#!/bin/sh

PATH=$PATH:~/Qt/5.13.0/ios/bin

lupdate ../longcat.pro -ts ../translations/longcat_ru.src.ts
lupdate ../qml         -ts ../translations/longcat_ru.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_ja.src.ts
lupdate ../qml         -ts ../translations/longcat_ja.qml.ts

lconvert ../translations/longcat_ru.src.ts ../translations/longcat_ru.qml.ts -o ../translations/longcat_ru.ts
lconvert ../translations/longcat_ja.src.ts ../translations/longcat_ja.qml.ts -o ../translations/longcat_ja.ts
