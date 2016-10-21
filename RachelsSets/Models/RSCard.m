//
//  RSCard.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSCard.h"

#import "NSMutableArray+RSExtensions.h"
#import "RSModel_Protected.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static NSArray *COLOR_NAMES = nil;

static NSArray *COUNT_NAMES = nil;

static NSArray *FILL_NAMES = nil;

static NSArray *SHAPE_NAMES = nil;

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSCard

+ (void) initialize {
    if (self != [RSCard class]) return;

    COLOR_NAMES = @[ @"red", @"green", @"blue" ];
    COUNT_NAMES = @[ @"", @"single", @"double", @"triple" ];
    FILL_NAMES = @[ @"solid", @"semi", @"hollow" ];
    SHAPE_NAMES = @[ @"circle", @"square", @"triangle" ];
}

- (id) initWithColor:(RSCardColor)color count:(RSCardCount)count fill:(RSCardFill)fill shape:(RSCardShape)shape {
    if ((self = [super init])) {
        self.color = color;
        self.count = count;
        self.fill = fill;
        self.shape = shape;
    }

    return self;
}

- (void) setInHintSet:(BOOL)inHintSet {
    if (_inHintSet == inHintSet) return;
    _inHintSet = inHintSet;

    [self postUpdatedNotification];
}

- (void) setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;

    [self postUpdatedNotification];
}

// Static Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

+ (RSCard*) cardWithColor:(RSCardColor)color count:(RSCardCount)count fill:(RSCardFill)fill shape:(RSCardShape)shape {
    return [[RSCard alloc] initWithColor:color count:count fill:fill shape:shape];
}

+ (NSMutableArray*) fullDeck {
    NSInteger deckCount = RSCardColorCount * RSCardCountCount * RSCardFillCount * RSCardShapeCount;
    NSMutableArray *deck = [NSMutableArray arrayWithCapacity:deckCount];

    for (RSCardColor color = 0; color < RSCardColorCount; color++) {
        for (RSCardCount count = 1; count <= RSCardCountCount; count++) {
            for (RSCardFill fill = 0; fill < RSCardFillCount; fill++) {
                for (RSCardShape shape = 0; shape < RSCardShapeCount; shape++) {
                    [deck addObject:[RSCard cardWithColor:color count:count fill:fill shape:shape]];
                }
            }
        }
    }

    [deck shuffle];
    return deck;
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) makesSetWith:(RSCard*)second and:(RSCard*)third {
    BOOL allSame = NO, allDifferent = NO;

    for (NSString *key in @[ @"color", @"count", @"fill", @"shape" ]) {
        allSame = [self valueForKey:key] == [second valueForKey:key];
        allSame = allSame && [self valueForKey:key] == [third valueForKey:key];

        allDifferent = [self valueForKey:key] != [second valueForKey:key];
        allDifferent = allDifferent && [self valueForKey:key] != [third valueForKey:key];
        allDifferent = allDifferent && [second valueForKey:key] != [third valueForKey:key];

        if (! (allSame || allDifferent)) return NO;
    }
    return YES;
}

- (NSString*) name {
    return [NSString stringWithFormat:@"%@-%@", COUNT_NAMES[self.count], self.pipName];
}

- (NSString*) pipName {
    return [NSString stringWithFormat:@"%@-%@-%@",
        [COLOR_NAMES objectAtIndex:self.color],
        [FILL_NAMES objectAtIndex:self.fill],
        [SHAPE_NAMES objectAtIndex:self.shape]
    ];
}

// NSObject Methods ////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) description {
    return self.name;
}

@end

// Helper Extensions Public Implementation /////////////////////////////////////////////////////////////////////////////

@implementation NSMutableArray (RSCard)

- (BOOL) isValidSet {
    if (self.count != RSCardCardsInValidSet) return NO;
    return [[self objectAtIndex:0] makesSetWith:[self objectAtIndex:1] and:[self objectAtIndex:2]];
}

- (RSCard*) removeTopCard {
    RSCard *card = [self lastObject];
    [self removeLastObject];
    return card;
}

@end
