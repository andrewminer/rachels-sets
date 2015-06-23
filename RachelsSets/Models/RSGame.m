//
//  RSGame.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGame.h"

#import "RSCard.h"
#import "RSGameBoard.h"
#import "RSModel_Protected.h"

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGame ()

@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, assign) NSTimeInterval stopTime;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGame

// Inits ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {
    if ((self = [super init])) {
        self.board = [[RSGameBoard alloc] init];
        [self reset];
    }
    return self;
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) addRow {
    for (NSInteger index = 0; index < RSCardCardsInValidSet; index++) {
        [self.board addCard:[self.deck removeTopCard]];
    }
    [self postUpdatedNotification];
    return YES;
}

- (NSTimeInterval) elapsedTime {
    if (self.startTime == 0) return 0;
    if (self.stopTime == 0) return [NSDate timeIntervalSinceReferenceDate] - self.startTime;
    return self.stopTime - self.startTime;
}

- (BOOL) isOver {
    if (self.deck.count > 0) return NO;
    if ([self.board hasSet]) return NO;
    return YES;
}

- (void) reset {
    [self.board reset];
    self.completedSets = [NSMutableArray array];
    self.deck = [RSCard fullDeck];
    self.selectedCards = [NSMutableArray arrayWithCapacity:RSCardCardsInValidSet];
    self.startTime = 0;
    self.stopTime = 0;

    [self postUpdatedNotification];
}

- (void) selectCard:(RSCard*)card {
    if (card.isSelected) {
        [self.selectedCards removeObject:card];
        card.selected = NO;
        return;
    }

    if (self.selectedCards.count < RSCardCardsInValidSet) {
        [self.selectedCards addObject:card];
        card.selected = YES;
    }
    if (self.selectedCards.count < RSCardCardsInValidSet) return;

    if ([self.selectedCards isValidSet]) {
        BOOL shouldAddCards = self.board.allCards.count <= RSGameBoardPreferredCount;

        for (RSCard *card in self.selectedCards) {
            [self.board removeCard:card];
            if (shouldAddCards) {
                [self.board addCard:[self.deck removeTopCard]];
            }
        }
        [self.completedSets addObject:self.selectedCards];
        self.selectedCards = [NSMutableArray arrayWithCapacity:RSCardCardsInValidSet];
    } else {
        [self unselectAll];
    }

    while (! [self.board hasSet]) {
        for (NSInteger i = 0; i < RSCardCardsInValidSet; i++) {
            [self.board addCard:[self.deck removeTopCard]];
        }
    }

    [self.board compactEmptyPositions];
    [self.board markHintSet];
    [self postUpdatedNotification];
}

- (void) start {
    for (NSInteger i = 0; i < RSGameBoardPreferredCount; i++) {
        [self.board addCard:[self.deck removeTopCard]];
    }
    self.startTime = [NSDate timeIntervalSinceReferenceDate];

    [self.board markHintSet];
    [self postUpdatedNotification];
}

- (void) stop {
    self.stopTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void) unselectAll {
    for (RSCard *card in self.selectedCards) {
        card.selected = NO;
    }
    [self.selectedCards removeAllObjects];
}

@end
