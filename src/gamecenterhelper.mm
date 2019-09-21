#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#include <QtCore/QDebug>

#include "gamecenterhelper.h"

const QString GameCenterHelper::GC_LEADERBOARD_ID(QStringLiteral("longcat.leaderboard.score"));

@interface GameCenterControllerDelegate : NSObject<GKGameCenterControllerDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHelper:(GameCenterHelper *)helper NS_DESIGNATED_INITIALIZER;
- (void)removeHelperAndAutorelease;
- (void)authenticate;
- (void)showLeaderboard;
- (void)reportScore:(int)value;

@end

@implementation GameCenterControllerDelegate
{
    BOOL              GameCenterEnabled;
    GameCenterHelper *GameCenterHelperInstance;
}

- (instancetype)initWithHelper:(GameCenterHelper *)helper
{
    self = [super init];

    if (self != nil) {
        GameCenterEnabled        = NO;
        GameCenterHelperInstance = helper;
    }

    return self;
}

- (void)removeHelperAndAutorelease
{
    GameCenterHelperInstance = nullptr;

    [self autorelease];
}

- (void)authenticate
{
    UIViewController * __block root_view_controller = nil;

    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
        root_view_controller = window.rootViewController;

        *stop = (root_view_controller != nil);
    }];

    GKLocalPlayer *local_player = GKLocalPlayer.localPlayer;

    if (@available(iOS 7, *)) {
        local_player.authenticateHandler = ^(UIViewController *view_controller, NSError *error) {
            if (error != nil) {
                qWarning() << QString::fromNSString(error.localizedDescription);

                GameCenterEnabled = NO;

                if (GameCenterHelperInstance != nullptr) {
                    GameCenterHelperInstance->setGameCenterEnabled(GameCenterEnabled);
                }
            } else {
                if (view_controller != nil) {
                    [root_view_controller presentViewController:view_controller animated:YES completion:nil];
                } else if (local_player.isAuthenticated) {
                    GameCenterEnabled = YES;

                    if (GameCenterHelperInstance != nullptr) {
                        GameCenterHelperInstance->setGameCenterEnabled(GameCenterEnabled);
                    }

                    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];

                    leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                    [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                        if (error != nil) {
                            qWarning() << QString::fromNSString(error.localizedDescription);
                        } else {
                            if (GameCenterHelperInstance != nullptr && leaderboard.localPlayerScore != nil) {
                                GameCenterHelperInstance->setPlayerScore(static_cast<int>(leaderboard.localPlayerScore.value));
                                GameCenterHelperInstance->setPlayerRank(static_cast<int>(leaderboard.localPlayerScore.rank));
                            }
                        }

                        [leaderboard autorelease];
                    }];
                } else {
                    GameCenterEnabled = NO;

                    if (GameCenterHelperInstance != nullptr) {
                        GameCenterHelperInstance->setGameCenterEnabled(GameCenterEnabled);
                    }
                }
            }
        };
    } else {
        assert(0);
    }
}

- (void)showLeaderboard
{
    if (GameCenterEnabled) {
        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        if (@available(iOS 7, *)) {
            GKGameCenterViewController *gc_view_controller = [[[GKGameCenterViewController alloc] init] autorelease];

            gc_view_controller.gameCenterDelegate    = self;
            gc_view_controller.viewState             = GKGameCenterViewControllerStateLeaderboards;
            gc_view_controller.leaderboardIdentifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

            [root_view_controller presentViewController:gc_view_controller animated:YES completion:nil];
        } else {
            assert(0);
        }
    }
}

- (void)reportScore:(int)value
{
    if (GameCenterEnabled && value > 0) {
        GKScore *score = [[[GKScore alloc] initWithLeaderboardIdentifier:GameCenterHelper::GC_LEADERBOARD_ID.toNSString()] autorelease];

        score.value = value;

        if (@available(iOS 7, *)) {
            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    qWarning() << QString::fromNSString(error.localizedDescription);
                } else {
                    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];

                    leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                    [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                        if (error != nil) {
                            qWarning() << QString::fromNSString(error.localizedDescription);
                        } else {
                            if (GameCenterHelperInstance != nullptr && leaderboard.localPlayerScore != nil) {
                                GameCenterHelperInstance->setPlayerScore(static_cast<int>(leaderboard.localPlayerScore.value));
                                GameCenterHelperInstance->setPlayerRank(static_cast<int>(leaderboard.localPlayerScore.rank));
                            }
                        }

                        [leaderboard autorelease];
                    }];
                }
            }];
        } else {
            assert(0);
        }
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController API_AVAILABLE(ios(6))
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

GameCenterHelper::GameCenterHelper(QObject *parent) : QObject(parent)
{
    GameCenterEnabled                    = false;
    PlayerScore                          = 0;
    PlayerRank                           = 0;
    GameCenterControllerDelegateInstance = [[GameCenterControllerDelegate alloc] initWithHelper:this];
}

GameCenterHelper::~GameCenterHelper() noexcept
{
    [GameCenterControllerDelegateInstance removeHelperAndAutorelease];
}

GameCenterHelper &GameCenterHelper::GetInstance()
{
    static GameCenterHelper instance;

    return instance;
}

bool GameCenterHelper::gameCenterEnabled() const
{
    return GameCenterEnabled;
}

int GameCenterHelper::playerScore() const
{
    return PlayerScore;
}

int GameCenterHelper::playerRank() const
{
    return PlayerRank;
}

void GameCenterHelper::authenticate()
{
    [GameCenterControllerDelegateInstance authenticate];
}

void GameCenterHelper::showLeaderboard()
{
    [GameCenterControllerDelegateInstance showLeaderboard];
}

void GameCenterHelper::reportScore(int score)
{
    [GameCenterControllerDelegateInstance reportScore:score];
}

void GameCenterHelper::setGameCenterEnabled(bool enabled)
{
    if (GameCenterEnabled != enabled) {
        GameCenterEnabled = enabled;

        emit gameCenterEnabledChanged(GameCenterEnabled);
    }
}

void GameCenterHelper::setPlayerScore(int score)
{
    if (PlayerScore != score) {
        PlayerScore = score;

        emit playerScoreChanged(PlayerScore);
    }
}

void GameCenterHelper::setPlayerRank(int rank)
{
    if (PlayerRank != rank) {
        PlayerRank = rank;

        emit playerRankChanged(PlayerRank);
    }
}
