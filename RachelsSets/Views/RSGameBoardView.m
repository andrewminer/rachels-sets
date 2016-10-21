//
//  RSGameBoardView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/12/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameBoardView.h"

#import "NSNumber+RSExtensions.h"
#import "RSCard.h"
#import "RSCardView.h"
#import "RSGameBoard.h"
#import "RSGeometry.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

enum {
    MIN_CARDS_PER_SIDE = 3,
};

static NSTimeInterval CARD_MOVE_DELAY = 0.1; // seconds

static NSTimeInterval DEAL_CARD_DURATION = 0.5; // seconds;

static CGFloat DEAL_INITIAL_ALPHA = 0.5;

static NSString *FOR_ADJUSTMENT = @"for-adjustment";

static NSString *FOR_DEALING = @"for-dealing";

static NSString *FOR_MOVEMENT = @"for-movement";

static NSString *FOR_REMOVAL = @"for-removal";

static NSTimeInterval REMOVE_CARD_DURATION = 0.25; // seconds

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoardView ()

@property (nonatomic, strong) NSTimer *cardMoveTimer;

@property (nonatomic, strong) NSMutableArray *cardsToMove;

@property (nonatomic, assign, readonly) NSInteger columnCount;

@property (nonatomic, strong) NSMutableDictionary *indexForCard;

@property (nonatomic, assign, readonly) NSInteger rowCount;

- (CGAffineTransform) cardRotation;

- (CGRect) computeCardFrameAtIndex:(NSInteger)index;

- (void) dequeueNextCard;

- (void) enqueueCard:(RSCardView*)cardView action:(NSString*)action atIndex:(NSInteger)index;

- (void) onTouchUpInside;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameBoardView

- (id) initWithDelegate:(id<RSGameBoardViewDelegate>)delegate {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.cardsToMove = [NSMutableArray array];
        self.delegate = delegate;
        self.indexForCard = [NSMutableDictionary dictionary];
        [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@synthesize cardMoveTimer = _cardMoveTimer;

- (void) setCardMoveTimer:(NSTimer*)cardMoveTimer {
    if (_cardMoveTimer == cardMoveTimer) return;
    [_cardMoveTimer invalidate];
    _cardMoveTimer = cardMoveTimer;
}

- (NSInteger) columnCount {
    if (self.frame.size.width > self.frame.size.height) {
        return MAX([self.delegate cardCountOnGameBoard:self], RSGameBoardPreferredCount) / MIN_CARDS_PER_SIDE;
    } else {
        return MIN_CARDS_PER_SIDE;
    }
}

- (NSInteger) rowCount {
    if (self.frame.size.width > self.frame.size.height) {
        return MIN_CARDS_PER_SIDE;
    } else {
        return MAX([self.delegate cardCountOnGameBoard:self], RSGameBoardPreferredCount) / MIN_CARDS_PER_SIDE;
    }
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) adjustCardPositions {
    [self enqueueCard:(RSCardView*)[NSNull null] action:FOR_ADJUSTMENT atIndex:0];
}

- (void) dealCard:(RSCardView*)card atIndex:(NSInteger)index animated:(BOOL)animated {
    if (animated) {
        [self enqueueCard:card action:FOR_DEALING atIndex:index];
    } else {
        card.tag = index;
        card.frame = [self computeCardFrameAtIndex:index];
        card.transform = [self cardRotation];
        [self addSubview:card];
        [self.cardsToMove removeObject:card];
    }
}

- (void) moveCard:(RSCardView*)card toIndex:(NSInteger)index animated:(BOOL)animated {
    if (card.tag == index) return;

    if (animated) {
        [self enqueueCard:card action:FOR_MOVEMENT atIndex:index];
    } else {
        card.tag = index;
        card.frame = [self computeCardFrameAtIndex:index];
        card.transform = [self cardRotation];
        [self.cardsToMove removeObject:card];
    }
}

- (void) removeCard:(RSCardView*)card animated:(BOOL)animated {
    if (animated) {
        [self enqueueCard:card action:FOR_REMOVAL atIndex:0];
    } else {
        [self.cardsToMove removeObject:card];
        [card removeFromSuperview];
    }
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGAffineTransform) cardRotation {
    return CGAffineTransformIdentity;

//    Uncomment to allow cards to appear to be rotated slightly when placed down.
//    return CGAffineTransformMakeRotation([NSNumber randomFloatFrom:-2 to:2] / 180.0 * M_PI);
}

- (void) dequeueNextCard {
    if (self.cardsToMove.count > 0) {
        NSDictionary *cardData = [self.cardsToMove firstObject];
        [self.cardsToMove removeObjectAtIndex:0];

        NSString *action = cardData[@"action"];
        RSCardView *cardView = cardData[@"card"];
        NSInteger index = [((NSNumber*)cardData[@"index"]) integerValue];
        CGRect finalFrame = [self computeCardFrameAtIndex:index];
        CGFloat delay = [NSNumber randomFloatFrom:0.0 to:0.25];

        if (action == FOR_ADJUSTMENT) {
            for (UIView *view in self.subviews) {
                if (view.tag == NSNotFound) continue;

                UIViewAnimationOptions options = UIViewAnimationOptionLayoutSubviews;
                [UIView animateWithDuration:DEAL_CARD_DURATION delay:delay options:options animations:^{
                    view.frame = [self computeCardFrameAtIndex:view.tag];
                } completion:nil];
            }
        } else if (action == FOR_DEALING) {
            cardView.alpha = DEAL_INITIAL_ALPHA;
            cardView.frame = [self computeCardFrameAtIndex:NSNotFound];
            cardView.tag = index;
            [self addSubview:cardView];

            [UIView animateWithDuration:DEAL_CARD_DURATION delay:delay usingSpringWithDamping:CARD_TOSS_DAMPING
                    initialSpringVelocity:CARD_TOSS_VELOCITY options:0 animations:^{
                cardView.frame = finalFrame;
                cardView.transform = [self cardRotation];
                cardView.alpha = 1.0;
            } completion:nil];
        } else if (action == FOR_MOVEMENT) {
            cardView.tag = index;
            [UIView animateWithDuration:DEAL_CARD_DURATION delay:delay options:0 animations:^{
                cardView.frame = finalFrame;
                cardView.transform = [self cardRotation];
            } completion:nil];
        } else if (action == FOR_REMOVAL) {
            [UIView animateWithDuration:REMOVE_CARD_DURATION delay:delay options:0 animations:^{
                cardView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [cardView removeFromSuperview];
            }];
        }
    }

    if (self.cardsToMove.count == 0) {
        self.cardMoveTimer = nil;
    }
}

- (CGRect) computeCardFrameAtIndex:(NSInteger)index {
    NSInteger rowCount = self.rowCount, columnCount = self.columnCount;
    if (rowCount == 0 || columnCount == 0) return CGRectZero;
    
    CGSize cellSize = CGSizeMake(self.bounds.size.width / columnCount, self.bounds.size.height / rowCount);
    CGRect frame = {0, 0, cellSize.width, cellSize.height};

    if (index != NSNotFound) {
        NSInteger rowIndex = index / self.columnCount;
        NSInteger columnIndex = index - (rowIndex * self.columnCount);
        frame.origin.x = columnIndex * cellSize.width;
        frame.origin.y = rowIndex * cellSize.height;
    } else {
        frame.origin.x = (self.bounds.size.width - frame.size.width) / 2.0;
        frame.origin.y = self.bounds.size.height * 2.0;
    }

    return CGRectFloor(frame);
}

- (void) onTouchUpInside {
    [self.delegate gameBoardTouched:self];
}

- (void) enqueueCard:(RSCardView*)cardView action:(NSString*)action atIndex:(NSInteger)index {
    if (self.cardsToMove.count == 0) {
        self.cardMoveTimer = [NSTimer scheduledTimerWithTimeInterval:CARD_MOVE_DELAY
            target:self selector:@selector(dequeueNextCard) userInfo:nil repeats:YES];
    }
    id cardValue = (cardView == nil) ? [NSNull null] : cardView;
    id actionValue = (action == nil) ? [NSNull null] : action;
    [self.cardsToMove addObject:@{ @"card": cardValue, @"action": actionValue, @"index": @(index) }];
}

@end
