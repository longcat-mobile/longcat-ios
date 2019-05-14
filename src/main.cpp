#include <QtCore/QString>
#include <QtCore/QLocale>
#include <QtCore/QTranslator>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "admobhelper.h"
#include "sharehelper.h"
#include "storehelper.h"
#include "gamecenterhelper.h"
#include "reachabilityhelper.h"

int main(int argc, char *argv[])
{
    QTranslator     translator;
    QGuiApplication app(argc, argv);

    if (translator.load(QString(":/tr/longcat_%1").arg(QLocale::system().name()))) {
        QGuiApplication::installTranslator(&translator);
    }

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(QStringLiteral("AdMobHelper"), &AdMobHelper::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("ShareHelper"), &ShareHelper::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("StoreHelper"), &StoreHelper::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("GameCenterHelper"), &GameCenterHelper::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("ReachabilityHelper"), &ReachabilityHelper::GetInstance());

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return QGuiApplication::exec();
}
