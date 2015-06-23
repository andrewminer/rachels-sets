//
//  NSNumber+RSExtensions.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "NSNumber+RSExtensions.h"

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSNumber (RSExtensions)

+ (CGFloat) randomFloatFrom:(CGFloat)minimum to:(CGFloat)maximum {
    return ((CGFloat)random() / (CGFloat)RAND_MAX) * (maximum - minimum) + minimum;
}

+ (NSInteger) randomIntegerFrom:(NSInteger)minimum to:(NSInteger)maximum {
    return random() % (maximum - minimum) + minimum;
}

+ (void) seedRandomizer {
    srandom([NSDate timeIntervalSinceReferenceDate]);
}

@end
