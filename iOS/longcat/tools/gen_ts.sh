#!/bin/sh

PATH=$PATH:~/Qt/5.9.1/ios/bin

lupdate ../longcat.pro -ts ../translations/longcat_ru.src.ts
lupdate ../qml         -ts ../translations/longcat_ru.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_de.src.ts
lupdate ../qml         -ts ../translations/longcat_de.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_fr.src.ts
lupdate ../qml         -ts ../translations/longcat_fr.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_zh.src.ts
lupdate ../qml         -ts ../translations/longcat_zh.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_es.src.ts
lupdate ../qml         -ts ../translations/longcat_es.qml.ts

lupdate ../longcat.pro -ts ../translations/longcat_it.src.ts
lupdate ../qml         -ts ../translations/longcat_it.qml.ts

lconvert ../translations/longcat_ru.src.ts ../translations/longcat_ru.qml.ts -o ../translations/longcat_ru.ts
lconvert ../translations/longcat_de.src.ts ../translations/longcat_de.qml.ts -o ../translations/longcat_de.ts
lconvert ../translations/longcat_fr.src.ts ../translations/longcat_fr.qml.ts -o ../translations/longcat_fr.ts
lconvert ../translations/longcat_zh.src.ts ../translations/longcat_zh.qml.ts -o ../translations/longcat_zh.ts
lconvert ../translations/longcat_es.src.ts ../translations/longcat_es.qml.ts -o ../translations/longcat_es.ts
lconvert ../translations/longcat_it.src.ts ../translations/longcat_it.qml.ts -o ../translations/longcat_it.ts
