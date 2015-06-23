//
//  RSGameBoardViewController.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/14/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSCard, RSGameBoard;

@protocol RSGameBoardViewControllerDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoardViewController : UIViewController

@property (nonatomic, weak) id<RSGameBoardViewControllerDelegate> delegate;

@property (nonatomic, strong) RSGameBoard *gameBoard;

- (id) initWithGameBoard:(RSGameBoard*)gameBoard andDelegate:(id<RSGameBoardViewControllerDelegate>)delegate;

- (void) refresh:(BOOL)animated;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSGameBoardViewControllerDelegate <NSObject>
@optional

- (void) gameBoard:(RSGameBoardViewController*)controller cardTouched:(RSCard*)card;

- (void) gameBoardTouched:(RSGameBoardViewController*)controller;

@end
