//
//  RSGameViewController.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameViewController.h"

#import "RSGame.h"
#import "RSGameBoardViewController.h"
#import "RSGameRecord.h"
#import "RSGameView.h"

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameViewController () <RSGameBoardViewControllerDelegate, RSGameViewDelegate>

@property (nonatomic, strong, readonly) RSGameView *gameView;

@property (nonatomic, strong) RSGameBoardViewController *gameBoardViewController;

@property (nonatomic, strong) NSTimer *refreshTimer;

- (void) onRefreshTimerFired;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameViewController

- (id) initWithGame:(RSGame*)game {
    if ((self = [super init])) {
        self.game = game;
        self.gameBoardViewController = [[RSGameBoardViewController alloc]
            initWithGameBoard:self.game.board andDelegate:self];
        [self addChildViewController:self.gameBoardViewController];
    }
    return self;
}

- (RSGameView*) gameView {
    return (RSGameView*) self.view;
}

@synthesize gameBoardViewController = _gameBoardViewController;

- (void) setGameBoardViewController:(RSGameBoardViewController*)gameBoardViewController {
    if (_gameBoardViewController == gameBoardViewController) return;
    [_gameBoardViewController removeFromParentViewController];
    _gameBoardViewController = gameBoardViewController;
    [self addChildViewController:_gameBoardViewController];
}

@synthesize refreshTimer = _refreshTimer;

- (void) setRefreshTimer:(NSTimer*)refreshTimer {
    if (_refreshTimer == refreshTimer) return;
    [_refreshTimer invalidate];
    _refreshTimer = refreshTimer;
}

// UIViewController Methods ////////////////////////////////////////////////////////////////////////////////////////////

- (void) loadView {
    self.view = [[RSGameView alloc] initWithDelegate:self];
    self.gameView.gameBoardView = (RSGameBoardView*) self.gameBoardViewController.view;
    self.gameView.mode = RSGameViewModeMainMenu;
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) onRefreshTimerFired {
    [self.gameView refresh];
}

// RSGameBoardViewControllerDelegate Methods ///////////////////////////////////////////////////////////////////////////

- (void) gameBoard:(RSGameBoardViewController*)controller cardTouched:(RSCard*)card {
    [self.game selectCard:card];

    if (self.game.isOver) {
        [self.game stop];
        [self.record recordTime:self.game.elapsedTime];

        self.gameView.mode = RSGameViewModeGameOver;
        self.refreshTimer = nil;
    }
}

- (void) gameBoardTouched:(RSGameBoardViewController*)controller {
    [self.game unselectAll];
}

// RSGameViewDelegate Methods //////////////////////////////////////////////////////////////////////////////////////////

- (NSTimeInterval) bestTimeForGameView:(RSGameView*)gameView {
    return self.record.bestTime;
}

- (NSTimeInterval) elapsedTimeForGameView:(RSGameView*)gameView {
    return self.game.elapsedTime;
}

- (void) gameViewAddRowButtonPressed:(RSGameView *)gameView {
    [self.game addRow];
}

- (void) gameViewDidChangeMode:(RSGameView*)gameView {
    if (gameView.mode == RSGameViewModePlaying) {
        [self.game start];
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
            target:self selector:@selector(onRefreshTimerFired) userInfo:nil repeats:YES];
    } else if (gameView.mode == RSGameViewModeMainMenu) {
        [self.game reset];
        [self.gameView refresh];
    }
}

- (void) gameViewStartButtonPressed:(RSGameView*)gameView {
    if (self.gameView.mode == RSGameViewModePlaying) return;
    self.gameView.mode = RSGameViewModePlaying;
}

- (void) gameViewQuitButtonPressed:(RSGameView*)gameView {
    if (self.gameView.mode == RSGameViewModeMainMenu) return;
    self.gameView.mode = RSGameViewModeMainMenu;
}

- (NSTimeInterval) lastTimeForGameView:(RSGameView*)gameView {
    return self.record.lastTime;
}

@end
