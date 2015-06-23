//
//  RSGameBoard.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameBoard.h"

#import "RSCard.h"
#import "RSModel_Protected.h"

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoard ()

@property (nonatomic, strong) NSMutableArray *cards;

- (void) clearHintSet;

- (NSArray*) findHintSet;

- (BOOL) isActualCard:(id)candidate;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameBoard

// Inits ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {
    if ((self = [super init])) {
        self.cards = [NSMutableArray array];
    }
    return self;
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) addCard:(RSCard*)card {
    if (card == nil) return;

    for (NSInteger index = 0; index < self.cards.count; index++) {
        id existingCard = self.cards[index];
        if (! [self isActualCard:existingCard]) {
            self.cards[index] = card;
            [self postUpdatedNotification];
            return;
        }
    }

    [self.cards addObject:card];
    [self postUpdatedNotification];
    return;
}

- (NSArray*) allCards {
    return self.cards;
}

- (void) compactEmptyPositions {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.cards.count];
    for (id card in self.cards) {
        if ([self isActualCard:card]) {
            [result addObject:card];
        }
    }
    self.cards = result;
    [self postUpdatedNotification];
}

- (BOOL) hasEmptySpaces {
    for (id card in self.cards) {
        if (! [self isActualCard:card]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) hasSet {
    for (RSCard *first in self.cards) {
        if ((id)first == (id)[NSNull null]) return YES;

        for (RSCard *second in self.cards) {
            if ((id)second == (id)[NSNull null]) return YES;
            if (first == second) continue;

            for (RSCard *third in self.cards) {
                if ((id)third == (id)[NSNull null]) return YES;
                if (first == third) continue;
                if (second == third) continue;

                if ([first makesSetWith:second and:third]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (void) markHintSet {
    [self clearHintSet];
    NSArray *hintSet = [self findHintSet];
    if (! hintSet) return;
    
    for (RSCard *card in hintSet) {
        card.inHintSet = true;
    }
}

- (void) removeCard:(RSCard*)card {
    NSUInteger index = [self.cards indexOfObject:card];
    if (index == NSNotFound) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
            reason:@"Card not present on game board" userInfo:@{@"card": card}];
    }

    if (self.cards.count <= RSGameBoardPreferredCount) {
        [self.cards replaceObjectAtIndex:index withObject:[NSNull null]];
    } else {
        [self.cards removeObject:card];
    }

    [self postUpdatedNotification];
}

- (void) reset {
    [self.cards removeAllObjects];
    [self postUpdatedNotificationWithUserInfo:@{@"animated": @(NO)}];
}

// NSObject Methods ////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) description {
    return [NSString stringWithFormat:@"Board:%@", self.cards];
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) clearHintSet {
    for (RSCard *card in self.cards) {
        card.inHintSet = false;
    }
}

- (NSArray*) findHintSet {
    for (RSCard *first in self.cards) {
        if (! [self isActualCard:first]) continue;

        for (RSCard *second in self.cards) {
            if (! [self isActualCard:second]) continue;
            if (first == second) continue;

            for (RSCard *third in self.cards) {
                if (! [self isActualCard:third]) continue;
                if (first == third) continue;
                if (second == third) continue;

                if ([first makesSetWith:second and:third]) {
                    return @[first, second, third];
                }
            }
        }
    }
    return nil;
}

- (BOOL) isActualCard:(id)candidate {
    if (candidate == nil) return NO;
    if (candidate == [NSNull null]) return NO;
    if ([candidate class] != [RSCard class]) return NO;
    return YES;
}

@end
