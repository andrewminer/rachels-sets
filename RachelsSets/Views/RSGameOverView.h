//
//  RSGameOverView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/23/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSRoundRectView.h"

@protocol RSGameOverViewDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameOverView : UIControl

@property (nonatomic, weak) id<RSGameOverViewDelegate> delegate;

- (id) initWithDelegate:(id<RSGameOverViewDelegate>)delegate;

- (void) refresh;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSGameOverViewDelegate <NSObject>

- (NSTimeInterval) bestTimeForGameOverView:(RSGameOverView*)gameOverView;

- (NSTimeInterval) lastTimeForGameOverView:(RSGameOverView*)gameOverView;

@optional

- (void) gameOverViewTapped:(RSGameOverView*)gameOverView;

@end