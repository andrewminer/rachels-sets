//
//  RSGameView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameView.h"

#import "NSNumber+RSExtensions.h"
#import "RSGame.h"
#import "RSGameBoardView.h"
#import "RSGameOverView.h"
#import "RSGeometry.h"
#import "RSMainMenuView.h"
#import "RSPlayingStatusBarView.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static UIColor *BACKGROUND_COLOR = nil;

static UIEdgeInsets GAME_BOARD_PADDING = {8, 8, 8, 8};

static CGFloat GAME_OVER_DURATION_FACTOR = 3.0;

static CGSize GAME_OVER_SIZE_FACTOR = (CGSize) { 0.66, 0.33 };

static NSTimeInterval MODE_CHANGE_DURATION = 0.5; // seconds

static UIEdgeInsets PADDING = {20, 0, 0, 0};

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameView () <RSGameOverViewDelegate, RSMainMenuViewDelegate, RSPlayingStatusBarViewDelegate>

@property (nonatomic, strong) RSGameOverView *gameOverView;

@property (nonatomic, strong) RSMainMenuView *mainMenuView;

@property (nonatomic, strong) RSPlayingStatusBarView *playingStatusBarView;

- (void) makeGameOverVisible:(BOOL)visible animated:(BOOL)animated;

- (void) makeGameBoardVisible:(BOOL)visible animated:(BOOL)animated;

- (void) makeMainMenuVisible:(BOOL)visible animated:(BOOL)animated;

- (void) makePlayingStatusBarVisible:(BOOL)visible animated:(BOOL)animated;

- (void) onGameModeChanged;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameView

+ (void) initialize {
    if (self != [RSGameView class]) return;

    BACKGROUND_COLOR = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0];
}

- (id) initWithDelegate:(id<RSGameViewDelegate>)delegate {
    if ((self = [super init])) {
        self.backgroundColor = BACKGROUND_COLOR;
        self.opaque = NO;

        self.delegate = delegate;

        self.gameOverView = [[RSGameOverView alloc] initWithDelegate:self];
        self.gameOverView.alpha = 0.0;
        self.gameOverView.hidden = YES;

        self.mainMenuView = [[RSMainMenuView alloc] initWithDelegate:self];
        self.mainMenuView.alpha = 1.0;

        self.playingStatusBarView = [[RSPlayingStatusBarView alloc] initWithDelegate:self];
        self.playingStatusBarView.alpha = 0.0;
        self.playingStatusBarView.hidden = YES;
    }
    return self;
}

@synthesize gameBoardView = _gameBoardView;

- (void) setGameBoardView:(RSGameBoardView *)gameBoardView {
    if (_gameBoardView == gameBoardView) return;
    [_gameBoardView removeFromSuperview];
    _gameBoardView = gameBoardView;
    [self addSubview:_gameBoardView];
    [self setNeedsLayout];

    _gameBoardView.hidden = (self.mode == RSGameViewModeMainMenu);
    _gameBoardView.alpha = (self.mode == RSGameViewModeMainMenu) ? 0.0 :
        (self.mode == RSGameViewModePlaying) ? 1.0 : 0.5;
}

@synthesize gameOverView = _gameOverView;

- (void) setGameOverView:(RSGameOverView*)gameOverView {
    if (_gameOverView == gameOverView) return;
    [_gameBoardView removeFromSuperview];
    _gameOverView = gameOverView;
    [self addSubview:_gameOverView];
    [self setNeedsLayout];
}

@synthesize mainMenuView = _mainMenuView;

- (void) setMainMenuView:(RSMainMenuView*)mainMenuView {
    if (_mainMenuView == mainMenuView) return;
    [_mainMenuView removeFromSuperview];
    _mainMenuView = mainMenuView;
    [self addSubview:_mainMenuView];
    [self setNeedsLayout];
}

- (void) setMode:(RSGameViewMode)mode {
    [self setMode:mode animated:YES];
}

- (void) setMode:(RSGameViewMode)mode animated:(BOOL)animated {
    if (_mode == mode) return;
    _mode = mode;

    BOOL showGameBoard = (_mode != RSGameViewModeMainMenu);
    BOOL showGameOver = (_mode == RSGameViewModeGameOver);
    BOOL showMainMenu = (_mode == RSGameViewModeMainMenu);
    BOOL showPlayingStatusBar = (_mode != RSGameViewModeMainMenu);

    [self makeGameBoardVisible:showGameBoard animated:animated];
    [self makeGameOverVisible:showGameOver animated:animated];
    [self makeMainMenuVisible:showMainMenu animated:animated];
    [self makePlayingStatusBarVisible:showPlayingStatusBar animated:animated];

    self.gameBoardView.userInteractionEnabled = (_mode == RSGameViewModePlaying);

    NSTimeInterval delay = animated ? MODE_CHANGE_DURATION : 0.0;
    [self performSelector:@selector(onGameModeChanged) withObject:nil afterDelay:delay];
}

- (void) setPlayingStatusBarView:(RSPlayingStatusBarView*)playingStatusBarView {
    if (_playingStatusBarView == playingStatusBarView) return;
    [_playingStatusBarView removeFromSuperview];
    _playingStatusBarView = playingStatusBarView;
    [self addSubview:_playingStatusBarView];
    [self setNeedsLayout];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) refresh {
    [self.playingStatusBarView refresh];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) layoutSubviews {
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, PADDING);
    CGRect frame = bounds;

    frame.size.width = bounds.size.width / 2.0;
    frame.size.height = [self.mainMenuView sizeThatFits:frame.size].height;
    frame.origin.x = bounds.origin.x + (bounds.size.width - frame.size.width) / 2.0;
    frame.origin.y = bounds.origin.y + (bounds.size.height - frame.size.height) / 2.0;
    self.mainMenuView.frame = CGRectFloor(frame);

    frame = bounds;
    frame.size.height = 0;
    frame.size.height = [self.playingStatusBarView sizeThatFits:frame.size].height;
    frame.origin.y = bounds.origin.y + bounds.size.height - frame.size.height;
    self.playingStatusBarView.frame = CGRectFloor(frame);

    frame.size.height = bounds.size.height - frame.size.height;
    frame.origin.y = bounds.origin.y;
    frame = UIEdgeInsetsInsetRect(frame, GAME_BOARD_PADDING);
    self.gameBoardView.frame = CGRectFloor(frame);

    CGFloat baseSize = CGSizeMinDimension(bounds.size);
    frame.size = (CGSize) { baseSize * GAME_OVER_SIZE_FACTOR.width, baseSize * GAME_OVER_SIZE_FACTOR.height };
    frame.origin.x = bounds.origin.x + ((bounds.size.width - frame.size.width) / 2.0);
    frame.origin.y = bounds.origin.y + ((bounds.size.height - frame.size.height) / 2.0);
    self.gameOverView.frame = CGRectFloor(frame);

    [self bringSubviewToFront:self.gameBoardView];
    [self bringSubviewToFront:self.mainMenuView];
    [self bringSubviewToFront:self.playingStatusBarView];
    [self bringSubviewToFront:self.gameOverView];
}

// RSGameOverViewDelegate Methods //////////////////////////////////////////////////////////////////////////////////////

- (NSTimeInterval) bestTimeForGameOverView:(RSGameOverView*)gameOverView {
    return [self.delegate bestTimeForGameView:self];
}

- (void) gameOverViewTapped:(RSGameOverView*)gameOverView {
    [self.delegate gameViewQuitButtonPressed:self];
}

- (NSTimeInterval) lastTimeForGameOverView:(RSGameOverView*)gameOverView {
    return [self.delegate lastTimeForGameView:self];
}

// RSMainMenuViewDelegate Methods //////////////////////////////////////////////////////////////////////////////////////

- (void) mainMenuViewStartButtonTouched:(RSMainMenuView*)mainMenuView {
    [self.delegate gameViewStartButtonPressed:self];
}

// RSPlayingStatusBarViewDelegate Methods //////////////////////////////////////////////////////////////////////////////

- (NSTimeInterval) elapsedTimeForPlayingStatusBar:(RSPlayingStatusBarView*)statusBarView {
    return [self.delegate elapsedTimeForGameView:self];
}

- (void) playingStatusBarAddRowButtonPressed:(RSPlayingStatusBarView*)statusBarView {
    [self.delegate gameViewAddRowButtonPressed:self];
}

- (void) playingStatusBarQuitButtonPressed:(RSPlayingStatusBarView*)statusBarView {
    [self.delegate gameViewQuitButtonPressed:self];
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) makeGameOverVisible:(BOOL)visible animated:(BOOL)animated {
    if (self.gameOverView.hidden != visible) return;
    NSTimeInterval duration = animated ? MODE_CHANGE_DURATION : 0.0;

    if (visible) {
        CGRect targetFrame = self.gameOverView.frame;
        CGRect initialFrame = self.gameOverView.frame;
        initialFrame.origin.y += self.bounds.size.height;
        CGFloat rotation = [NSNumber randomIntegerFrom:0 to:5] / 180.0 * M_PI;

        self.gameOverView.hidden = NO;
        self.gameOverView.transform = CGAffineTransformIdentity;
        self.gameOverView.frame = initialFrame;
        [self.gameOverView refresh];

        duration *= GAME_OVER_DURATION_FACTOR;
        [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:CARD_TOSS_DAMPING
                initialSpringVelocity:CARD_TOSS_VELOCITY options:0 animations:^{
            self.gameBoardView.alpha = 0.5;
            self.gameOverView.alpha = 1.0;
            self.gameOverView.frame = targetFrame;
            self.gameOverView.transform = CGAffineTransformMakeRotation(rotation);
        } completion:nil];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.gameOverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.gameOverView.hidden = YES;
        }];
    }
}

- (void) makeGameBoardVisible:(BOOL)visible animated:(BOOL)animated {
    if (self.gameBoardView.hidden != visible) return;
    NSTimeInterval duration = animated ? MODE_CHANGE_DURATION : 0.0;

    if (visible) {
        self.gameBoardView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            self.gameBoardView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.gameBoardView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.gameBoardView.hidden = YES;
        }];
    }
}

- (void) makeMainMenuVisible:(BOOL)visible animated:(BOOL)animated {
    if (self.mainMenuView.hidden != visible) return;
    NSTimeInterval duration = animated ? MODE_CHANGE_DURATION : 0.0;

    if (visible) {
        self.mainMenuView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            self.mainMenuView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.mainMenuView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.mainMenuView.hidden = YES;
        }];
    }
}

- (void) makePlayingStatusBarVisible:(BOOL)visible animated:(BOOL)animated {
    if (self.playingStatusBarView.hidden != visible) return;
    NSTimeInterval duration = animated ? MODE_CHANGE_DURATION : 0.0;

    if (visible) {
        CGRect targetFrame = self.playingStatusBarView.frame;
        CGRect initialFrame = targetFrame;
        initialFrame.origin.y = self.bounds.size.height;

        self.playingStatusBarView.hidden = NO;
        self.playingStatusBarView.alpha = 1.0;
        self.playingStatusBarView.frame = initialFrame;
        [UIView animateWithDuration:duration animations:^{
            self.playingStatusBarView.frame = targetFrame;
        }];
    } else {
        CGRect initialFrame = self.playingStatusBarView.frame;
        CGRect targetFrame = initialFrame;
        targetFrame.origin.y = self.bounds.size.height;

        [UIView animateWithDuration:duration animations:^{
            self.playingStatusBarView.frame = targetFrame;
        } completion:^(BOOL finished) {
            self.playingStatusBarView.hidden = YES;
            self.playingStatusBarView.frame = initialFrame;
        }];
    }
}

- (void) onGameModeChanged {
    [self.delegate gameViewDidChangeMode:self];
}

@end
