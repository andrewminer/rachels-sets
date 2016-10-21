//
//  RSPipView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/24/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSPipView.h"

#import "UIColor+RSExtensions.h"
#import "RSCard.h"
#import "RSGeometry.h"

#import <QuartzCore/QuartzCore.h>

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static NSArray *BORDER_COLORS = nil;

static CGFloat BORDER_WIDTH = 1.0;

static NSArray *FILL_COLORS = nil;

static CGFloat SEMI_ALPHA = 0.5;

static CGFloat HOLLOW_ALPHA = 0.0;

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSPipView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (void) updatePathOf:(CAShapeLayer*)shapeLayer;

- (void) refresh;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSPipView

+ (void) initialize {
    if (self != [RSPipView class]) return;

    BORDER_COLORS = @[
        [UIColor colorWithIntegerRed:162 green:0 blue:17 alpha:100],
        [UIColor colorWithIntegerRed:32 green:112 blue:35 alpha:100],
        [UIColor colorWithIntegerRed:32 green:61 blue:148 alpha:100],
    ];

    FILL_COLORS = @[
        [UIColor colorWithIntegerRed:221 green:22 blue:36 alpha:100],
        [UIColor colorWithIntegerRed:35 green:139 blue:29 alpha:100],
        [UIColor colorWithIntegerRed:45 green:73 blue:192 alpha:100],
    ];

    BORDER_WIDTH = CGSizeMinDimension([UIScreen mainScreen].bounds.size) / 300.0;
}

+ (NSArray*) pipViewsForCard:(RSCard*)card {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:card.count];
    while (result.count < card.count) {
        [result addObject:[[RSPipView alloc] initWithColor:card.color fill:card.fill shape:card.shape]];
    }
    return result;
}

- (id) initWithColor:(RSCardColor)color fill:(RSCardFill)fill shape:(RSCardShape)shape {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.color = color;
        self.fill = fill;
        self.shape = shape;
        self.userInteractionEnabled = NO;

        [self refresh];
    }
    return self;
}

@synthesize color = _color;

- (void) setColor:(RSCardColor)color {
    if (_color == color) return;
    _color = color;

    [self refresh];
}

@synthesize fill = _fill;

- (void) setFill:(RSCardFill)fill {
    if (_fill == fill) return;
    _fill = fill;

    [self refresh];
}

@synthesize shape = _shape;

- (void) setShape:(RSCardShape)shape {
    if (_shape == shape) return;
    _shape = shape;

    [self refresh];
}

@synthesize shapeLayer = _shapeLayer;

- (void) setShapeLayer:(CAShapeLayer*)shapeLayer {
    if (_shapeLayer == shapeLayer) return;
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = shapeLayer;
    [self.layer addSublayer:_shapeLayer];

    [self refresh];
}

// UIView Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updatePathOf:self.shapeLayer];
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updatePathOf:(CAShapeLayer*)shapeLayer {
    CGFloat full = CGSizeMinDimension(self.bounds.size);
    CGFloat half = full / 2.0;
    CGFloat zero = 0.0;

    CGMutablePathRef path = CGPathCreateMutable();
    if (self.shape == RSCardShapeCircle) {
        CGPathMoveToPoint(path, nil, zero, half);
        CGPathAddArc(path, nil, half, half, half, M_PI, M_PI / 2.0, YES);
        CGPathAddArc(path, nil, half, half, half, M_PI / 2.0, 0.0, YES);
        CGPathAddArc(path, nil, half, half, half, 0.0, -M_PI / 2.0, YES);
        CGPathAddArc(path, nil, half, half, half, -M_PI / 2.0, M_PI, YES);
    } else if (self.shape == RSCardShapeSquare) {
        CGPathMoveToPoint(path, nil, zero, zero);
        CGPathAddLineToPoint(path, nil, zero, full);
        CGPathAddLineToPoint(path, nil, full, full);
        CGPathAddLineToPoint(path, nil, full, zero);
        CGPathAddLineToPoint(path, nil, zero, zero);
    } else if (self.shape == RSCardShapeTriangle) {
        CGPathMoveToPoint(path, nil, zero, full);
        CGPathAddLineToPoint(path, nil, full, full);
        CGPathAddLineToPoint(path, nil, half, zero);
        CGPathAddLineToPoint(path, nil, half, zero);
        CGPathAddLineToPoint(path, nil, zero, full);
    }
    CGPathCloseSubpath(path);

    shapeLayer.path = path;
    CGPathRelease(path);
}

- (void) refresh {
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
    }
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = BORDER_WIDTH;
    self.shapeLayer.strokeColor = [BORDER_COLORS[self.color] CGColor];

    UIColor *fillColor = nil;
    if (self.fill == RSCardFillHollow) {
        fillColor = [FILL_COLORS[self.color] colorWithAlphaComponent:HOLLOW_ALPHA];
        self.shapeLayer.lineWidth *= 2.0;
    } else if (self.fill == RSCardFillSemi) {
        fillColor = [FILL_COLORS[self.color] colorWithAlphaComponent:SEMI_ALPHA];
        self.shapeLayer.lineDashPattern = @[
            [NSNumber numberWithFloat:BORDER_WIDTH],
            [NSNumber numberWithFloat:BORDER_WIDTH]
        ];
        self.shapeLayer.lineWidth /= 2.0;
    } else if (self.fill == RSCardFillSolid) {
        fillColor = FILL_COLORS[self.color];
    }
    self.shapeLayer.fillColor = [fillColor CGColor];
    
    [self updatePathOf:self.shapeLayer];
}

@end
