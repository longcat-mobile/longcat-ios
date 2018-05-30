#!/bin/sh

PATH=$PATH:~/Qt/5.9.1/ios/bin

lupdate ../longcat.pro -ts ../translations/longcat_ru.src.ts
lupdate ../qml         -ts ../translations/longcat_ru.qml.ts

lconvert ../translations/longcat_ru.src.ts ../translations/longcat_ru.qml.ts -o ../translations/longcat_ru.ts
