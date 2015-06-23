//
//  RSGameView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSGame, RSGameBoardView;

@protocol RSGameViewDelegate;

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    RSGameViewModeMainMenu,
    RSGameViewModePlaying,
    RSGameViewModeGameOver,
} RSGameViewMode;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameView : UIView

@property (nonatomic, weak) id<RSGameViewDelegate> delegate;

@property (nonatomic, strong) RSGameBoardView *gameBoardView;

@property (nonatomic, assign) RSGameViewMode mode;

- (id) initWithDelegate:(id<RSGameViewDelegate>)delegate;

- (void) refresh;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSGameViewDelegate <NSObject>

- (NSTimeInterval) bestTimeForGameView:(RSGameView*)gameView;

- (NSTimeInterval) elapsedTimeForGameView:(RSGameView*)gameView;

- (NSTimeInterval) lastTimeForGameView:(RSGameView*)gameView;

@optional

- (void) gameViewAddRowButtonPressed:(RSGameView*)gameView;

- (void) gameViewStartButtonPressed:(RSGameView*)gameView;

- (void) gameViewQuitButtonPressed:(RSGameView*)gameView;

- (void) gameViewDidChangeMode:(RSGameView*)gameView;

@end
