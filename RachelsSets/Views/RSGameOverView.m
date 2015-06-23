//
//  RSGameOverView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/23/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameOverView.h"

#import "NSString+RSExtensions.h"
#import "RSGeometry.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static UIColor *BORDER_COLOR = nil;

static CGFloat BORDER_THICKNESS = 0.0;

static CGFloat CORNER_SIZE_FACTOR = 1.0 / 8.0;

static UIColor *FILL_COLOR = nil;

static UIFont *TIME_FONT = nil;

static CGFloat TIME_FONT_SIZE_FACTOR = 1.0 / 32.0;

static UIFont *TITLE_FONT = nil;

static CGFloat TITLE_FONT_SIZE_FACTOR = 1.0 / 16.0;

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameOverView ()

@property (nonatomic, strong) RSRoundRectView *backgroundView;

@property (nonatomic, strong) UILabel *bestTimeLabel;

@property (nonatomic, strong) UILabel *lastTimeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

- (RSRoundRectView*) createBackgroundView;

- (UILabel*) createTimeLabel;

- (UILabel*) createTitleLabel;

- (NSString*) formatInterval:(NSTimeInterval)interval withLabel:(NSString*)label;

- (void) onTouched;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameOverView

+ (void) initialize {
    if (self != [RSGameOverView class]) return;
    CGFloat baseSize = CGSizeMaxDimension([UIScreen mainScreen].bounds.size);

    BORDER_COLOR = [UIColor clearColor];
    FILL_COLOR = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.80];
    TITLE_FONT = [UIFont boldSystemFontOfSize:baseSize * TITLE_FONT_SIZE_FACTOR];
    TIME_FONT = [UIFont systemFontOfSize:baseSize * TIME_FONT_SIZE_FACTOR];
}

- (id) initWithDelegate:(id<RSGameOverViewDelegate>)delegate {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.backgroundView = [self createBackgroundView];
        self.bestTimeLabel = [self createTimeLabel];
        self.lastTimeLabel = [self createTimeLabel];
        self.titleLabel = [self createTitleLabel];
        self.titleLabel.text = @"Game Over";

        [self addTarget:self action:@selector(onTouched) forControlEvents:UIControlEventTouchUpInside];

        [self setNeedsLayout];

        self.delegate = delegate; // must go last so that `refresh` functions properly
    }
    return self;
}

@synthesize backgroundView = _backgroundView;

- (void) setBackgroundView:(RSRoundRectView*)backgroundView {
    if (_backgroundView == backgroundView) return;
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    [self addSubview:_backgroundView];
    [self setNeedsLayout];
}

@synthesize bestTimeLabel = _bestTimeLabel;

- (void) setBestTimeLabel:(UILabel*)bestTimeLabel {
    if (_bestTimeLabel == bestTimeLabel) return;
    [_bestTimeLabel removeFromSuperview];
    _bestTimeLabel = bestTimeLabel;
    [self addSubview:_bestTimeLabel];
    [self setNeedsLayout];
}

@synthesize delegate = _delegate;

- (void) setDelegate:(id<RSGameOverViewDelegate>)delegate {
    if (_delegate == delegate) return;
    _delegate = delegate;
    [self refresh];
}

@synthesize lastTimeLabel = _lastTimeLabel;

- (void) setLastTimeLabel:(UILabel*)lastTimeLabel {
    if (_lastTimeLabel == lastTimeLabel) return;
    [_lastTimeLabel removeFromSuperview];
    _lastTimeLabel = lastTimeLabel;
    [self addSubview:_lastTimeLabel];
    [self setNeedsLayout];
}

@synthesize titleLabel = _titleLabel;

- (void) setTitleLabel:(UILabel*)titleLabel {
    if (_titleLabel == titleLabel) return;
    [_titleLabel removeFromSuperview];
    _titleLabel = titleLabel;
    [self addSubview:_titleLabel];
    [self setNeedsLayout];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) refresh {
    self.bestTimeLabel.text = [self formatInterval:[self.delegate bestTimeForGameOverView:self] withLabel:@"best"];
    self.lastTimeLabel.text = [self formatInterval:[self.delegate lastTimeForGameOverView:self] withLabel:@"last"];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.cornerRadius = CGSizeMinDimension(self.bounds.size) * CORNER_SIZE_FACTOR;
}

- (void) layoutSubviews {
    CGRect frame = self.bounds;
    self.backgroundView.frame = frame;

    [self.titleLabel sizeToFit];
    [self.bestTimeLabel sizeToFit];
    [self.lastTimeLabel sizeToFit];

    CGFloat totalMargin = self.bounds.size.height - self.titleLabel.frame.size.height -
        self.bestTimeLabel.frame.size.height;

    frame.size = self.titleLabel.frame.size;
    frame.origin.x = floor(self.bounds.size.width - frame.size.width) / 2.0;
    frame.origin.y = floor(totalMargin / 3.0);
    self.titleLabel.frame = frame;

    frame.size = self.bestTimeLabel.bounds.size;
    frame.origin.x = self.titleLabel.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + floor(totalMargin / 3.0);
    self.bestTimeLabel.frame = frame;

    frame.size = self.lastTimeLabel.bounds.size;
    frame.origin.x = CGRectGetMaxX(self.titleLabel.frame) - frame.size.width;
    frame.origin.y = self.bestTimeLabel.frame.origin.y;
    self.lastTimeLabel.frame = frame;

}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (RSRoundRectView*) createBackgroundView {
    RSRoundRectView *view = [RSRoundRectView new];
    view.borderThickness = BORDER_THICKNESS;
    view.borderColor = BORDER_COLOR;
    view.fillColor = FILL_COLOR;
    return view;
}

- (UILabel*) createTimeLabel {
    UILabel *label = [UILabel new];
    label.font = TIME_FONT;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (UILabel*) createTitleLabel {
    UILabel *label = [UILabel new];
    label.font = TITLE_FONT;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (NSString*) formatInterval:(NSTimeInterval)interval withLabel:(NSString*)label {
    return [NSString stringWithFormat:@"%@: %@", label, [NSString stringWithMinutesSeconds:interval]];
}

- (void) onTouched {
    [self.delegate gameOverViewTapped:self];
}

@end
