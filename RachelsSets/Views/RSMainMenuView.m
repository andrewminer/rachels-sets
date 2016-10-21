//
//  RSMainMenuView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSMainMenuView.h"

#import "RSGeometry.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static UIEdgeInsets PADDING = {8, 8, 8, 8};

static CGFloat BUTTON_SIZE_FACTOR = 1.0 / 16.0;

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSMainMenuView ()

@property (nonatomic, strong) UIButton *startButton;

- (UIButton*) createStartButton;

- (void) onStartButtonTouched;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSMainMenuView

- (id) initWithDelegate:(id<RSMainMenuViewDelegate>)delegate {
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        self.opaque = NO;
        self.startButton = [self createStartButton];
    }
    return self;
}

- (void) setStartButton:(UIButton*)startButton {
    if (_startButton == startButton) return;
    [_startButton removeFromSuperview];
    _startButton = startButton;
    [self addSubview:_startButton];
    [self setNeedsLayout];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) layoutSubviews {
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, PADDING);
    CGRect frame = { bounds.origin, bounds.size.width, self.startButton.frame.size.height };

    frame.origin.y = bounds.origin.y + (bounds.size.height - frame.size.height) / 2.0;
    self.startButton.frame = CGRectFloor(frame);
}

- (CGSize) sizeThatFits:(CGSize)size {
    size.height = self.startButton.frame.size.height;
    return size;
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIButton*) createStartButton {
    CGFloat fontSize = CGSizeMaxDimension([UIScreen mainScreen].bounds.size) * BUTTON_SIZE_FACTOR;
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(onStartButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [startButton sizeToFit];
    return startButton;
}

- (void) onStartButtonTouched {
    [self.delegate mainMenuViewStartButtonTouched:self];
}

@end
