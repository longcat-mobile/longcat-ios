#ifndef GAMECENTERHELPER_H
#define GAMECENTERHELPER_H

#include <QtCore/QObject>
#include <QtCore/QString>

#ifdef __OBJC__
@class GameCenterControllerDelegate;
#endif

class GameCenterHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool gameCenterEnabled READ gameCenterEnabled NOTIFY gameCenterEnabledChanged)

public:
    explicit GameCenterHelper(QObject *parent = 0);
    virtual ~GameCenterHelper();

    bool gameCenterEnabled() const;

    Q_INVOKABLE void initialize();
    Q_INVOKABLE void showLeaderboard();

    static void setGameCenterEnabled(const bool &enabled);

signals:
    void gameCenterEnabledChanged(bool gameCenterEnabled);

private:
    bool                          Initialized, GameCenterEnabled;
    static GameCenterHelper      *Instance;
#ifdef __OBJC__
    GameCenterControllerDelegate *GameCenterControllerDelegateInstance;
#else
    void                         *GameCenterControllerDelegateInstance;
#endif
};

#endif // GAMECENTERHELPER_H
