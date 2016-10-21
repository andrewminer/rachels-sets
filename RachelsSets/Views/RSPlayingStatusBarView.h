//
//  RSPlayingStatusBarView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@protocol RSPlayingStatusBarViewDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSPlayingStatusBarView : UIView

@property (nonatomic, weak) id<RSPlayingStatusBarViewDelegate> delegate;

- (id) initWithDelegate:(id<RSPlayingStatusBarViewDelegate>)delegate;

- (void) refresh;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSPlayingStatusBarViewDelegate <NSObject>

- (NSTimeInterval) elapsedTimeForPlayingStatusBar:(RSPlayingStatusBarView*)statusBarView;

@optional

- (void) playingStatusBarAddRowButtonPressed:(RSPlayingStatusBarView*)statusBarView;

- (void) playingStatusBarQuitButtonPressed:(RSPlayingStatusBarView*)statusBarView;

@end
