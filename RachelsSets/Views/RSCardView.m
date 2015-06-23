//
//  RSCardView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/8/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSCardView.h"

#import "RSCard.h"
#import "RSGeometry.h"
#import "RSPipView.h"
#import "RSRoundRectView.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat ASPECT_RATIO = 3.0 / 4.0;

static CGFloat CORNER_SIZE_FACTOR = 1.0 / 10.0;

static UIColor *HINT_COLOR = nil;

static UIColor *NORMAL_COLOR = nil;

static CGFloat PIP_MARGIN = 0.2;

static CGFloat PIP_SIZE_FACTOR = 1.0 / 5.0;

static UIColor *ROUND_RECT_COLOR = nil;

static UIEdgeInsets ROUND_RECT_INSETS = { 4.0, 4.0, 4.0, 4.0 };

static UIColor *SELECTED_COLOR = nil;

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSCardView ()

@property (nonatomic, strong) NSArray *pipViews;

@property (nonatomic, strong) RSRoundRectView *roundRectView;

- (void) onTouchUpInside;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSCardView

+ (void) initialize {
    if (self != [RSCardView class]) return;

    HINT_COLOR = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
    NORMAL_COLOR = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    ROUND_RECT_COLOR = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    SELECTED_COLOR = [UIColor colorWithRed:1.0 green:1.0 blue:0.75 alpha:1.0];
}

- (id) initWithDelegate:(id<RSCardViewDelegate>)delegate {
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.opaque = NO;

        self.roundRectView = [[RSRoundRectView alloc] init];
        self.roundRectView.borderColor = ROUND_RECT_COLOR;
        self.roundRectView.fillColor = NORMAL_COLOR;

        [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        self.delegate = delegate; // Set last so that `refresh` works as expected
    }
    return self;
}

@synthesize roundRectView = _roundRectView;

- (void) setRoundRectView:(RSRoundRectView*)roundRectView {
    if (_roundRectView == roundRectView) return;
    [_roundRectView removeFromSuperview];
    _roundRectView = roundRectView;
    [self addSubview:_roundRectView];
    [self setNeedsLayout];
}

@synthesize delegate = _delegate;

- (void) setDelegate:(id<RSCardViewDelegate>)delegate {
    _delegate = delegate;
    [self refresh];
}

@synthesize pipViews = _pipViews;

- (void) setPipViews:(NSArray*)pipViews {
    if (_pipViews == pipViews) return;
    [_pipViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _pipViews = pipViews;
    for (UIView *pipView in _pipViews) {
        [self addSubview:pipView];
    }
    [self setNeedsLayout];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) refresh {
    RSCard *card = [self.delegate cardForCardView:self];
    self.pipViews = [RSPipView pipViewsForCard:card];
    if (card.isSelected) {
        self.roundRectView.fillColor = SELECTED_COLOR;
    } else if (card.isInHintSet && TESTING_MODE) {
        self.roundRectView.fillColor = HINT_COLOR;
    } else {
        self.roundRectView.fillColor = NORMAL_COLOR;
    }
    [self setNeedsLayout];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) layoutSubviews {
    CGRect frame = CGRectZero;

    if (self.pipViews.count > 0) {
        CGFloat singlePipHeight = floor(self.bounds.size.height * PIP_SIZE_FACTOR);
        NSInteger pipCount = self.pipViews.count;
        CGFloat totalPipHeight = (singlePipHeight * pipCount) + (floor((PIP_MARGIN * singlePipHeight) * (pipCount - 1)));

        frame = (CGRect) { 0, 0, singlePipHeight, singlePipHeight };
        frame.origin.x = (self.bounds.size.width - frame.size.width) / 2.0;
        frame.origin.y = (self.bounds.size.height - totalPipHeight) / 2.0;

        for (UIView *pipView in self.pipViews) {
            pipView.frame = CGRectFloor(frame);
            frame.origin.y += frame.size.height * (1.0 + PIP_MARGIN);
            [self bringSubviewToFront:pipView];
        }
    }

    frame = UIEdgeInsetsInsetRect(self.bounds, ROUND_RECT_INSETS);
    frame.size.width = frame.size.height * ASPECT_RATIO;
    frame.origin.x = (self.bounds.size.width - frame.size.width) / 2.0;
    self.roundRectView.frame = CGRectFloor(frame);
    self.roundRectView.cornerRadius = floor(frame.size.width * CORNER_SIZE_FACTOR);
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) onTouchUpInside {
    [self.delegate cardViewTouched:self];
}

@end
