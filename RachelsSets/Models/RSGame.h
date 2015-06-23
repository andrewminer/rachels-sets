//
//  RSGame.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSModel.h"

@class RSCard, RSGameBoard;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGame : RSModel

@property (nonatomic, strong) RSGameBoard *board;

@property (nonatomic, strong) NSMutableArray *deck;

@property (nonatomic, strong) NSMutableArray *selectedCards;

@property (nonatomic, strong) NSMutableArray *completedSets;

- (BOOL) addRow;

- (NSTimeInterval) elapsedTime;

- (BOOL) isOver;

- (void) reset;

- (void) selectCard:(RSCard*)card;

- (void) start;

- (void) stop;

- (void) unselectAll;

@end
