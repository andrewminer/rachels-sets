//
//  RSGameBoardView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/12/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSCardView;

@protocol RSGameBoardViewDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoardView : UIControl

@property (nonatomic, weak) id<RSGameBoardViewDelegate> delegate;

- (id) initWithDelegate:(id<RSGameBoardViewDelegate>)delegate;

- (void) adjustCardPositions;

- (void) dealCard:(RSCardView*)cardView atIndex:(NSInteger)index animated:(BOOL)animated;

- (void) moveCard:(RSCardView*)cardView toIndex:(NSInteger)index animated:(BOOL)animated;

- (void) removeCard:(RSCardView*)cardView animated:(BOOL)animated;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSGameBoardViewDelegate <NSObject>

- (NSInteger) cardCountOnGameBoard:(RSGameBoardView*)gameBoardView;

@optional

- (void) gameBoardTouched:(RSGameBoardView*)gameBoardView;

@end
