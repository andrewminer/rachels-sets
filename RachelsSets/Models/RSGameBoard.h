//
//  RSGameBoard.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSModel.h"

@class RSCard;

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

enum {
    RSGameBoardPreferredCount = 12,
};

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoard : RSModel

- (void) addCard:(RSCard*)card;

- (NSArray*) allCards;

- (void) compactEmptyPositions;

- (BOOL) hasEmptySpaces;

- (BOOL) hasSet;

- (void) markHintSet;

- (void) removeCard:(RSCard*)card;

- (void) reset;

@end
