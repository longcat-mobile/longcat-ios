import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.12

import "Core/Dialog"

ApplicationWindow {
    id:         mainWindow
    title:      qsTr("Longcat")
    visibility: Window.FullScreen
    visible:    true

    property string adMobConsent: ""

    onAdMobConsentChanged: {
        setSetting("AdMobConsent", adMobConsent);

        updateFeatures();
    }

    function setSetting(key, value) {
        var db = LocalStorage.openDatabaseSync("LongcatDB", "1.0", "LongcatDB", 1000000);

        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SETTINGS(KEY TEXT PRIMARY KEY, VALUE TEXT)");

            tx.executeSql("REPLACE INTO SETTINGS (KEY, VALUE) VALUES (?, ?)", [key, value]);
        });
    }

    function getSetting(key, defaultValue) {
        var value = defaultValue;
        var db    = LocalStorage.openDatabaseSync("LongcatDB", "1.0", "LongcatDB", 1000000);

        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SETTINGS(KEY TEXT PRIMARY KEY, VALUE TEXT)");

            var res = tx.executeSql("SELECT VALUE FROM SETTINGS WHERE KEY=?", [key]);

            if (res.rows.length > 0) {
                value = res.rows.item(0).VALUE;
            }
        });

        return value;
    }

    function updateFeatures() {
        if (adMobConsent === "PERSONALIZED" || adMobConsent === "NON_PERSONALIZED") {
            AdMobHelper.setPersonalization(adMobConsent === "PERSONALIZED");

            AdMobHelper.initAds();
        }

        if (mainStackView.depth > 0 && typeof mainStackView.currentItem.bannerViewHeight === "number") {
            AdMobHelper.showBannerView();
        } else {
            AdMobHelper.hideBannerView();
        }
    }

    StackView {
        id:           mainStackView
        anchors.fill: parent

        onCurrentItemChanged: {
            for (var i = 0; i < depth; i++) {
                var item = get(i, StackView.DontLoad);

                if (item) {
                    item.focus = false;
                }
            }

            if (depth > 0) {
                currentItem.forceActiveFocus();

                if (typeof currentItem.bannerViewHeight === "number") {
                    AdMobHelper.showBannerView();
                } else {
                    AdMobHelper.hideBannerView();
                }
            } else {
                AdMobHelper.hideBannerView();
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        z:            1
        enabled:      mainStackView.busy
    }

    AdMobConsentDialog {
        id: adMobConsentDialog

        onPersonalizedAdsSelected: {
            mainWindow.adMobConsent = "PERSONALIZED";
        }

        onNonPersonalizedAdsSelected: {
            mainWindow.adMobConsent = "NON_PERSONALIZED";
        }
    }

    Component.onCompleted: {
        adMobConsent = getSetting("AdMobConsent", "");

        updateFeatures();

        var component = Qt.createComponent("Core/MainPage.qml");

        if (component.status === Component.Ready) {
            mainStackView.push(component);
        } else {
            console.error(component.errorString());
        }

        if (adMobConsent !== "PERSONALIZED" && adMobConsent !== "NON_PERSONALIZED") {
            adMobConsentDialog.open();
        }
    }
}
