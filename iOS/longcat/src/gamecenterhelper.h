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
    Q_PROPERTY(int  playerScore       READ playerScore       NOTIFY playerScoreChanged)
    Q_PROPERTY(int  playerRank        READ playerRank        NOTIFY playerRankChanged)

public:
    static const QString GC_LEADERBOARD_ID;

    explicit GameCenterHelper(QObject *parent = 0);
    virtual ~GameCenterHelper();

    bool gameCenterEnabled() const;
    int playerScore() const;
    int playerRank() const;

    Q_INVOKABLE void initialize();
    Q_INVOKABLE void showLeaderboard();
    Q_INVOKABLE void reportScore(int score);

    static void setGameCenterEnabled(const bool &enabled);
    static void setPlayerScore(const int &score);
    static void setPlayerRank(const int &rank);

signals:
    void gameCenterEnabledChanged(bool gameCenterEnabled);
    void playerScoreChanged(int playerScore);
    void playerRankChanged(int playerRank);

private:
    bool                          Initialized, GameCenterEnabled;
    int                           PlayerScore, PlayerRank;
    static GameCenterHelper      *Instance;
#ifdef __OBJC__
    GameCenterControllerDelegate *GameCenterControllerDelegateInstance;
#else
    void                         *GameCenterControllerDelegateInstance;
#endif
};

#endif // GAMECENTERHELPER_H