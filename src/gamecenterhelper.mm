#import <GameKit/GameKit.h>

#include <QtCore/QDebug>

#include "gamecenterhelper.h"

const QString GameCenterHelper::GC_LEADERBOARD_ID("longcat.leaderboard.score");

GameCenterHelper *GameCenterHelper::Instance = NULL;

@interface GameCenterControllerDelegate : NSObject<GKGameCenterControllerDelegate>

- (id)init;
- (void)dealloc;
- (void)showLeaderboard;
- (void)reportScore:(int)value;

@end

@implementation GameCenterControllerDelegate
{
    BOOL GameCenterEnabled;
}

- (id)init
{
    self = [super init];

    if (self) {
        GameCenterEnabled = NO;

        UIViewController * __block root_view_controller = nil;

        [[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = [window rootViewController];

            *stop = (root_view_controller != nil);
        }];

        GKLocalPlayer *local_player = [GKLocalPlayer localPlayer];

        local_player.authenticateHandler = ^(UIViewController *view_controller, NSError *error) {
            if (error != nil) {
                qWarning() << QString::fromNSString([error localizedDescription]);

                GameCenterEnabled = NO;

                GameCenterHelper::setGameCenterEnabled(GameCenterEnabled);
            } else {
                if (view_controller != nil) {
                    [root_view_controller presentViewController:view_controller animated:YES completion:nil];
                } else if (local_player.isAuthenticated) {
                    GameCenterEnabled = YES;

                    GameCenterHelper::setGameCenterEnabled(GameCenterEnabled);

                    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];

                    leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                    [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                        if (error != nil) {
                            qWarning() << QString::fromNSString([error localizedDescription]);
                        } else {
                            if (leaderboard.localPlayerScore != nil) {
                                GameCenterHelper::setPlayerScore((int)leaderboard.localPlayerScore.value);
                                GameCenterHelper::setPlayerRank((int)leaderboard.localPlayerScore.rank);
                            }
                        }

                        [leaderboard autorelease];
                    }];
                } else {
                    GameCenterEnabled = NO;

                    GameCenterHelper::setGameCenterEnabled(GameCenterEnabled);
                }
            }
        };
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)showLeaderboard
{
    if (GameCenterEnabled) {
        UIViewController * __block root_view_controller = nil;

        [[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = [window rootViewController];

            *stop = (root_view_controller != nil);
        }];

        GKGameCenterViewController *gc_view_controller = [[[GKGameCenterViewController alloc] init] autorelease];

        gc_view_controller.gameCenterDelegate    = self;
        gc_view_controller.viewState             = GKGameCenterViewControllerStateLeaderboards;
        gc_view_controller.leaderboardIdentifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

        [root_view_controller presentViewController:gc_view_controller animated:YES completion:nil];
    }
}

- (void)reportScore:(int)value
{
    if (GameCenterEnabled) {
        if (value > 0) {
            GKScore *score = [[[GKScore alloc] initWithLeaderboardIdentifier:GameCenterHelper::GC_LEADERBOARD_ID.toNSString()] autorelease];

            score.value = value;

            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    qWarning() << QString::fromNSString([error localizedDescription]);
                } else {
                    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];

                    leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                    [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                        if (error != nil) {
                            qWarning() << QString::fromNSString([error localizedDescription]);
                        } else {
                            if (leaderboard.localPlayerScore != nil) {
                                GameCenterHelper::setPlayerScore((int)leaderboard.localPlayerScore.value);
                                GameCenterHelper::setPlayerRank((int)leaderboard.localPlayerScore.rank);
                            }
                        }

                        [leaderboard autorelease];
                    }];
                }
            }];
        }
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

GameCenterHelper::GameCenterHelper(QObject *parent) : QObject(parent)
{
    GameCenterEnabled                    = false;
    PlayerScore                          = 0;
    PlayerRank                           = 0;
    Instance                             = this;
    GameCenterControllerDelegateInstance = [[GameCenterControllerDelegate alloc] init];
}

GameCenterHelper::~GameCenterHelper()
{
    [GameCenterControllerDelegateInstance release];
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
    Instance->GameCenterEnabled = enabled;

    emit Instance->gameCenterEnabledChanged(Instance->GameCenterEnabled);
}

void GameCenterHelper::setPlayerScore(int score)
{
    Instance->PlayerScore = score;

    emit Instance->playerScoreChanged(Instance->PlayerScore);
}

void GameCenterHelper::setPlayerRank(int rank)
{
    Instance->PlayerRank = rank;

    emit Instance->playerRankChanged(Instance->PlayerRank);
}
