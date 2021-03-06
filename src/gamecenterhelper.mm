#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#include <QtCore/QDebug>

#include "gamecenterhelper.h"

const QString GameCenterHelper::GC_LEADERBOARD_ID(QStringLiteral("longcat.leaderboard.score"));

@interface GameCenterControllerDelegate : NSObject<GKGameCenterControllerDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHelper:(GameCenterHelper *)helper NS_DESIGNATED_INITIALIZER;
- (void)dealloc;
- (void)cleanupAndAutorelease;
- (void)authenticate;
- (void)showLeaderboard;
- (void)reportScore:(int)value;

@end

@implementation GameCenterControllerDelegate
{
    BOOL                        GameCenterEnabled;
    GKGameCenterViewController *GameCenterViewController;
    GameCenterHelper           *GameCenterHelperInstance;
}

- (instancetype)initWithHelper:(GameCenterHelper *)helper
{
    self = [super init];

    if (self != nil) {
        GameCenterEnabled        = NO;
        GameCenterHelperInstance = helper;

        GameCenterViewController = [[GKGameCenterViewController alloc] init];

        GameCenterViewController.gameCenterDelegate    = self;
        GameCenterViewController.viewState             = GKGameCenterViewControllerStateLeaderboards;
        GameCenterViewController.leaderboardIdentifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();
    }

    return self;
}

- (void)dealloc
{
    GameCenterViewController.gameCenterDelegate = nil;

    [GameCenterViewController release];

    [super dealloc];
}

- (void)cleanupAndAutorelease
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

    GKLocalPlayer * __block local_player = GKLocalPlayer.localPlayer;

    local_player.authenticateHandler = ^(UIViewController *view_controller, NSError *error) {
        if (error != nil) {
            qWarning() << QString::fromNSString(error.localizedDescription);

            GameCenterEnabled = NO;

            if (GameCenterHelperInstance != nullptr) {
                GameCenterHelperInstance->SetGameCenterEnabled(GameCenterEnabled);
            }
        } else {
            if (view_controller != nil) {
                [root_view_controller presentViewController:view_controller animated:YES completion:nil];
            } else if (local_player.isAuthenticated) {
                GameCenterEnabled = YES;

                if (GameCenterHelperInstance != nullptr) {
                    GameCenterHelperInstance->SetGameCenterEnabled(GameCenterEnabled);
                }

                GKLeaderboard * __block leaderboard = [[[GKLeaderboard alloc] init] autorelease];

                leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                    if (error != nil) {
                        qWarning() << QString::fromNSString(error.localizedDescription);
                    } else {
                        if (GameCenterHelperInstance != nullptr && leaderboard.localPlayerScore != nil) {
                            GameCenterHelperInstance->SetPlayerScore(static_cast<int>(leaderboard.localPlayerScore.value));
                            GameCenterHelperInstance->SetPlayerRank(static_cast<int>(leaderboard.localPlayerScore.rank));
                        }
                    }
                }];
            } else {
                GameCenterEnabled = NO;

                if (GameCenterHelperInstance != nullptr) {
                    GameCenterHelperInstance->SetGameCenterEnabled(GameCenterEnabled);
                }
            }
        }
    };
}

- (void)showLeaderboard
{
    if (GameCenterEnabled && GameCenterViewController != nil) {
        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        [root_view_controller presentViewController:GameCenterViewController animated:YES completion:nil];
    }
}

- (void)reportScore:(int)value
{
    if (GameCenterEnabled && value > 0) {
        GKScore *score = [[[GKScore alloc] initWithLeaderboardIdentifier:GameCenterHelper::GC_LEADERBOARD_ID.toNSString()] autorelease];

        score.value = value;

        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                qWarning() << QString::fromNSString(error.localizedDescription);
            } else {
                GKLeaderboard * __block leaderboard = [[[GKLeaderboard alloc] init] autorelease];

                leaderboard.identifier = GameCenterHelper::GC_LEADERBOARD_ID.toNSString();

                [leaderboard loadScoresWithCompletionHandler:^(NSArray*, NSError *error) {
                    if (error != nil) {
                        qWarning() << QString::fromNSString(error.localizedDescription);
                    } else {
                        if (GameCenterHelperInstance != nullptr && leaderboard.localPlayerScore != nil) {
                            GameCenterHelperInstance->SetPlayerScore(static_cast<int>(leaderboard.localPlayerScore.value));
                            GameCenterHelperInstance->SetPlayerRank(static_cast<int>(leaderboard.localPlayerScore.rank));
                        }
                    }
                }];
            }
        }];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController API_AVAILABLE(ios(6))
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

GameCenterHelper::GameCenterHelper(QObject *parent) :
    QObject                             (parent),
    GameCenterEnabled                   (false),
    PlayerScore                         (0),
    PlayerRank                          (0),
    GameCenterControllerDelegateInstance([[GameCenterControllerDelegate alloc] initWithHelper:this])
{
}

GameCenterHelper::~GameCenterHelper() noexcept
{
    [GameCenterControllerDelegateInstance cleanupAndAutorelease];
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

void GameCenterHelper::authenticate() const
{
    [GameCenterControllerDelegateInstance authenticate];
}

void GameCenterHelper::showLeaderboard() const
{
    [GameCenterControllerDelegateInstance showLeaderboard];
}

void GameCenterHelper::reportScore(int score) const
{
    [GameCenterControllerDelegateInstance reportScore:score];
}

void GameCenterHelper::SetGameCenterEnabled(bool enabled)
{
    if (GameCenterEnabled != enabled) {
        GameCenterEnabled = enabled;

        emit gameCenterEnabledChanged(GameCenterEnabled);
    }
}

void GameCenterHelper::SetPlayerScore(int score)
{
    if (PlayerScore != score) {
        PlayerScore = score;

        emit playerScoreChanged(PlayerScore);
    }
}

void GameCenterHelper::SetPlayerRank(int rank)
{
    if (PlayerRank != rank) {
        PlayerRank = rank;

        emit playerRankChanged(PlayerRank);
    }
}
