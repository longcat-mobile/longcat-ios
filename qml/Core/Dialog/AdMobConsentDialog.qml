import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "../../Util.js" as UtilScript

Popup {
    id:               adMobConsentDialog
    anchors.centerIn: Overlay.overlay
    padding:          UtilScript.pt(8)
    modal:            true
    closePolicy:      Popup.NoAutoClose

    signal personalizedAdsSelected()
    signal nonPersonalizedAdsSelected()

    background: Rectangle {
        color:        "#5dc0f5"
        border.width: UtilScript.pt(2)
        border.color: "#96d100"
    }

    contentItem: Rectangle {
        implicitWidth:  UtilScript.pt(300)
        implicitHeight: UtilScript.pt(300)
        color:          "transparent"

        ColumnLayout {
            anchors.fill:         parent
            anchors.topMargin:    UtilScript.pt(8)
            anchors.bottomMargin: UtilScript.pt(8)
            spacing:              UtilScript.pt(8)

            Text {
                text:                qsTr("We keep this app free by showing ads. Ad network will <a href=\"https://policies.google.com/technologies/ads\">collect data and use a unique identifier on your device</a> to show you ads. <b>Do you allow to use your data to tailor ads for you?</b>")
                color:               "blue"
                font.pointSize:      16
                font.family:         "Helvetica"
                horizontalAlignment: Text.AlignJustify
                verticalAlignment:   Text.AlignVCenter
                wrapMode:            Text.Wrap
                fontSizeMode:        Text.Fit
                minimumPointSize:    8
                textFormat:          Text.StyledText
                Layout.fillWidth:    true
                Layout.fillHeight:   true

                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }

            Rectangle {
                width:            UtilScript.pt(personalizedAdsButtonImage.sourceSize.width)
                height:           UtilScript.pt(personalizedAdsButtonImage.sourceSize.height)
                color:            "transparent"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Image {
                    id:           personalizedAdsButtonImage
                    anchors.fill: parent
                    source:       "qrc:/resources/images/dialog/button.png"
                    fillMode:     Image.PreserveAspectFit

                    Text {
                        anchors.fill:        parent
                        anchors.margins:     UtilScript.pt(8)
                        text:                qsTr("Yes, show me relevant ads")
                        color:               "black"
                        font.pointSize:      16
                        font.family:         "Helvetica"
                        font.bold:           true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment:   Text.AlignVCenter
                        wrapMode:            Text.NoWrap
                        fontSizeMode:        Text.Fit
                        minimumPointSize:    8
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            adMobConsentDialog.personalizedAdsSelected();
                            adMobConsentDialog.close();
                        }
                    }
                }
            }

            Rectangle {
                width:            UtilScript.pt(nonPersonalizedAdsButtonImage.sourceSize.width)
                height:           UtilScript.pt(nonPersonalizedAdsButtonImage.sourceSize.height)
                color:            "transparent"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Image {
                    id:           nonPersonalizedAdsButtonImage
                    anchors.fill: parent
                    source:       "qrc:/resources/images/dialog/button.png"
                    fillMode:     Image.PreserveAspectFit

                    Text {
                        anchors.fill:        parent
                        anchors.margins:     UtilScript.pt(8)
                        text:                qsTr("No, show me ads that are less relevant")
                        color:               "black"
                        font.pointSize:      16
                        font.family:         "Helvetica"
                        font.bold:           true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment:   Text.AlignVCenter
                        wrapMode:            Text.NoWrap
                        fontSizeMode:        Text.Fit
                        minimumPointSize:    8
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            adMobConsentDialog.nonPersonalizedAdsSelected();
                            adMobConsentDialog.close();
                        }
                    }
                }
            }
        }
    }
}
