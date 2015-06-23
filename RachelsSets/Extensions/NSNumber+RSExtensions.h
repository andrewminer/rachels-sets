//
//  NSNumber+RSExtensions.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSNumber (RSExtensions)

+ (NSInteger) randomIntegerFrom:(NSInteger)minimum to:(NSInteger)maximum;

+ (CGFloat) randomFloatFrom:(CGFloat)minimum to:(CGFloat)maximum;

+ (void) seedRandomizer;

@end
