//
//  RSPlayingStatusBarView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSPlayingStatusBarView.h"

#import "NSString+RSExtensions.h"
#import "RSGeometry.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static UIColor *BACKGROUND_COLOR = nil;

static UIColor *BORDER_COLOR = nil;

static CGFloat BORDER_WIDTH = 2.0;

static UIEdgeInsets PADDING = {4, 16, 4, 16};

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSPlayingStatusBarView ()

@property (nonatomic, strong) UIButton *addRowButton;

@property (nonatomic, strong) UILabel *elapsedTimeLabel;

@property (nonatomic, strong) UIButton *quitButton;

- (UIButton*) createAddRowButton;

- (UILabel*) createElapsedTimeLabel;

- (UIButton*) createQuitButton;

- (void) onAddRowButtonTapped;

- (void) onQuitButtonTapped;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSPlayingStatusBarView

+ (void) initialize {
    if (self != [RSPlayingStatusBarView class]) return;

    BACKGROUND_COLOR = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.8 alpha:1.0];
    BORDER_COLOR = [UIColor blackColor];
}

- (id) initWithDelegate:(id<RSPlayingStatusBarViewDelegate>)delegate {
    if ((self = [super init])) {
        self.backgroundColor = BACKGROUND_COLOR;
        self.opaque = YES;
        
        self.delegate = delegate;
        self.addRowButton = [self createAddRowButton];
        self.elapsedTimeLabel = [self createElapsedTimeLabel];
        self.quitButton = [self createQuitButton];

        [self refresh];
    }
    return self;
}

@synthesize addRowButton = _addRowButton;

- (void) setAddRowButton:(UIButton*)addRowButton {
    if (_addRowButton == addRowButton) return;
    [_addRowButton removeFromSuperview];
    _addRowButton = addRowButton;
    if (TESTING_MODE) {
        [self addSubview:_addRowButton];
    }
    [self setNeedsLayout];
}

@synthesize elapsedTimeLabel = _elapsedTimeLabel;

- (void) setElapsedTimeLabel:(UILabel*)elapsedTimeLabel {
    if (_elapsedTimeLabel == elapsedTimeLabel) return;
    [_elapsedTimeLabel removeFromSuperview];
    _elapsedTimeLabel = elapsedTimeLabel;
    [self addSubview:_elapsedTimeLabel];
    [self setNeedsLayout];
}

@synthesize quitButton = _quitButton;

- (void) setQuitButton:(UIButton*)quitButton {
    if (_quitButton == quitButton) return;
    [_quitButton removeFromSuperview];
    _quitButton = quitButton;
    [self addSubview:_quitButton];
    [self setNeedsLayout];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) refresh {
    NSTimeInterval elapsedTime = [self.delegate elapsedTimeForPlayingStatusBar:self];
    self.elapsedTimeLabel.text = [NSString stringWithMinutesSeconds:elapsedTime];
    [self setNeedsLayout];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [self.backgroundColor CGColor]);
    CGContextFillRect(c, self.bounds);
    CGContextSetFillColorWithColor(c, [BORDER_COLOR CGColor]);
    CGContextFillRect(c, (CGRect) {0, 0, self.bounds.size.width, BORDER_WIDTH});
}

- (void) layoutSubviews {
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, PADDING);
    CGRect frame = bounds;

    frame.size = [self.addRowButton sizeThatFits:bounds.size];
    frame.origin.x = bounds.origin.x;
    frame.origin.y = bounds.origin.y + (bounds.size.height - frame.size.height) / 2.0;
    self.addRowButton.frame = CGRectFloor(frame);

    frame.size = [self.quitButton sizeThatFits:bounds.size];
    frame.origin.x = bounds.origin.x + bounds.size.width - frame.size.width;
    frame.origin.y = bounds.origin.y + (bounds.size.height - frame.size.height) / 2.0;
    self.quitButton.frame = CGRectFloor(frame);

    frame.size = [self.elapsedTimeLabel sizeThatFits:bounds.size];
    frame.origin.x = bounds.origin.x + (bounds.size.width - frame.size.width) / 2.0;
    frame.origin.y = bounds.origin.y + (bounds.size.height - frame.size.height) / 2.0;
    self.elapsedTimeLabel.frame = CGRectFloor(frame);
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize result = [self.quitButton sizeThatFits:size];
    result.height += PADDING.top + PADDING.bottom;
    result.width += PADDING.left + PADDING.right;
    return (CGSize) { MAX(result.width, size.width), MAX(result.height, size.height) };
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIButton*) createAddRowButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Add Row" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onAddRowButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel*) createElapsedTimeLabel {
    UILabel *label = [UILabel new];
    return label;
}

- (UIButton*) createQuitButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Quit" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onQuitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) onAddRowButtonTapped {
    [self.delegate playingStatusBarAddRowButtonPressed:self];
}

- (void) onQuitButtonTapped {
    [self.delegate playingStatusBarQuitButtonPressed:self];
}

@end
