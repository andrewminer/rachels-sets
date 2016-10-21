//
//  RSRoundRectView.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/22/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSRoundRectView.h"

#import <QuartzCore/QuartzCore.h>

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSRoundRectView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSRoundRectView

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.borderColor = [UIColor blackColor];
        self.borderThickness = 1.0;
        self.cornerRadius = 8.0;
        self.fillColor = [UIColor whiteColor];
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

@synthesize borderColor = _borderColor;

- (void) setBorderColor:(UIColor*)borderColor {
    _borderColor = borderColor;
    [self setNeedsLayout];
}

@synthesize borderThickness = _borderThickness;

- (void) setBorderThickness:(CGFloat)borderThickness {
    _borderThickness = borderThickness;
    [self setNeedsLayout];
}

@synthesize cornerRadius = _cornerRadius;

- (void) setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

@synthesize fillColor = _fillColor;

- (void) setFillColor:(UIColor*)fillColor {
    _fillColor = fillColor;
    [self setNeedsLayout];
}

@synthesize shapeLayer = _shapeLayer;

- (void) setShapeLayer:(CAShapeLayer*)shapeLayer {
    if (_shapeLayer == shapeLayer) return;
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = shapeLayer;
    [self.layer addSublayer:_shapeLayer];
}

// Private Methods /////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) layoutSubviews {
    CGFloat inset = self.borderThickness / 2.0;
    UIEdgeInsets insets = (UIEdgeInsets) { inset, inset, inset, inset };
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, insets);
    CGFloat r, g, b, alpha;
    [self.fillColor getRed:&r green:&g blue:&b alpha:&alpha];

    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
    }
    self.shapeLayer.fillColor = [[self.fillColor colorWithAlphaComponent:1.0] CGColor];
    self.shapeLayer.lineWidth = self.borderThickness;
    self.shapeLayer.path = [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius] CGPath];
    self.shapeLayer.opacity = alpha;
    self.shapeLayer.strokeColor = [self.borderColor CGColor];
}

@end
