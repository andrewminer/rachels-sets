//
//  UIColor+RSExtensions.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/24/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "UIColor+RSExtensions.h"

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIColor (RSExtensions)

+ (UIColor*) colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100.0)];
}

@end
