//
//  NSMutableArray+RSExtensions.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "NSMutableArray+RSExtensions.h"
#import "NSNumber+RSExtensions.h"

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSMutableArray (RSExtensions)

- (void) shuffle {
    NSInteger count = [self count];
    NSInteger shuffleCount = [self count] * [self count];
    for (NSInteger i = shuffleCount; i >= 0; i--) {
        NSInteger a = [NSNumber randomIntegerFrom:0 to:count];
        NSInteger b = [NSNumber randomIntegerFrom:0 to:count];
        [self exchangeObjectAtIndex:a withObjectAtIndex:b];
    }
}

@end
